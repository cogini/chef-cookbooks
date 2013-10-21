#!/usr/bin/env python

from subprocess import Popen, PIPE
from os import path, makedirs
from shutil import rmtree
from Queue import Queue, Empty
from threading  import Thread
from random import choice
import json
import re


def enter_line(stream, line):
    stream.write(line + '\n')


def read_pipe_to_lines(stdout, lines):
    while True:
        line = stdout.readline()
        lines.put(line)


def process_lines(lines, stdin):

    files = []
    pattern = re.compile('\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}')

    try:
        while True:

            line = lines.get(True, 1).strip()

            if line.startswith(path.sep):
                # This is printed after a cd
                dir_path = line
                continue

            if not pattern.match(line):
                # Ignore lines not containing amrecover ls output
                continue

            tokens = line.split(None, 1)
            the_path = tokens[1]

            if the_path == '.':
                # Ignore current directory
                continue

            abs_path = path.join(dir_path, the_path)
            if abs_path.endswith(path.sep):
                enter_line(stdin, 'cd %s' % abs_path)
                enter_line(stdin, 'ls')
            else:
                files.append(abs_path)

    except Empty:
        return files


def get_file_list(config, hostname, disk):

    lines = Queue()

    p = Popen(['amrecover', config], stdin=PIPE, stdout=PIPE)
    stdin = p.stdin
    stdout = p.stdout

    enter_line(stdin, 'sethost %s' % hostname)
    enter_line(stdin, 'setdisk %s' % disk)
    enter_line(stdin, 'cd %s' % disk)
    enter_line(stdin, 'ls')

    read_thread = Thread(target=read_pipe_to_lines, args=(stdout, lines))
    read_thread.daemon = True
    read_thread.start()

    return process_lines(lines, stdin)


def test_extraction(config, hostname, disk, target):

    prefix = '/tmp/check-amanda'
    try:
        makedirs(prefix)
    except OSError:
        print 'Directory %s already exists.' % prefix

    output_path = path.join(prefix, target)

    p = Popen(['amrecover', config], stdin=PIPE, stdout=PIPE)
    stdin = p.stdin

    enter_line(stdin, 'lcd %s' % prefix)
    enter_line(stdin, 'sethost %s' % hostname)
    enter_line(stdin, 'setdisk %s' % disk)
    enter_line(stdin, 'add %s' % target)
    enter_line(stdin, 'extract')
    enter_line(stdin, 'Y')
    enter_line(stdin, 'Y')
    enter_line(stdin, 'exit')
    p.communicate()

    p = Popen(['file', output_path], stdin=PIPE, stdout=PIPE)
    output, error = p.communicate()
    print output.strip()
    assert error is None
    assert p.returncode == 0

    if not path.islink(output_path):
        size = path.getsize(output_path)
        assert size > 0
        print 'File size is %s.' % size

    rmtree(prefix)


def main():

    dna = json.load(open('/etc/chef/node.json'))
    locations = dna['amanda']['backup_locations']

    hosts = [host['hostname'] for host in locations]
    hostname = choice(hosts)

    disks = [host['locations'] for host in locations if host['hostname'] == hostname][0]
    disk = choice(disks)

    config = choice(('daily', 'weekly', 'monthly'))
    print 'Checking %s backup of %s:%s ...' % (config, hostname, disk)

    files = get_file_list(config, hostname, disk)
    print 'There are %s files.' % len(files)

    random_file = choice(files)

    print 'Trying to extract %s ...' % random_file
    test_extraction(config, hostname, disk, random_file[len(disk) + 1:])

    print 'Everything looks OK.'


if __name__ == '__main__':
    main()
