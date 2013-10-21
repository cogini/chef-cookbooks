#!/usr/bin/env python

from subprocess import Popen, PIPE
from os import path, makedirs
from shutil import rmtree
from Queue import Queue, Empty
from threading  import Thread
from random import choice
from datetime import datetime, timedelta
import json


def enter_line(stream, line):
    stream.write(line + '\n')


def write_dirs_to_pipe(dirs, stdin):
    try:
        while True:
            dir = dirs.get(True, 1)
            enter_line(stdin, 'cd %s' % dir)
            enter_line(stdin, 'ls')
    except Empty:
        #print 'No more dir to write'
        pass


def read_pipe_to_lines(stdout, lines):
    while True:
        line = stdout.readline()
        lines.put(line)


def process_lines(disk, lines, dirs, files):

    dir_path = disk

    try:
        while True:

            line = lines.get(True, 1).strip()

            if line.startswith(path.sep):
                # This is printed after a cd
                dir_path = line

            if not line.startswith(date):
                # Ignore lines not containing amrecover ls output
                continue

            tokens = line.split(None, 1)
            the_path = tokens[1]

            if the_path == '.':
                # Ignore current directory
                continue

            abs_path = path.join(dir_path, the_path)
            if abs_path.endswith(path.sep):
                dirs.put(abs_path)
            else:
                #print 'Adding', abs_path
                files.append(abs_path)

    except Empty:
        #print 'no more line to read'
        pass


def get_file_list():

    dirs = Queue()
    files = []
    lines = Queue()

    p = Popen(['amrecover', config], stdin=PIPE, stdout=PIPE)
    stdin = p.stdin
    stdout = p.stdout

    enter_line(stdin, 'sethost %s' % hostname)
    enter_line(stdin, 'setdisk %s' % disk)
    enter_line(stdin, 'setdate %s' % date)
    enter_line(stdin, 'ls')

    write_thread = Thread(target=write_dirs_to_pipe, args=(dirs, stdin))
    write_thread.daemon = True
    write_thread.start()

    read_thread = Thread(target=read_pipe_to_lines, args=(stdout, lines))
    read_thread.daemon = True
    read_thread.start()

    process_thread = Thread(target=process_lines, args=(disk, lines, dirs, files))
    process_thread.daemon = True
    process_thread.start()

    write_thread.join()
    process_thread.join()
    return files


prefix = '/tmp/check-amanda'
try:
    makedirs(prefix)
except OSError:
    print 'Directory %s already exists.' % prefix


dna = json.load(open('/etc/chef/node.json'))
locations = dna['amanda']['backup_locations']

hosts = [host['hostname'] for host in locations]
hostname = choice(hosts)

disks = [host['locations'] for host in locations if host['hostname'] == hostname][0]
disk = choice(disks)

config = choice(('daily', 'weekly', 'monthly'))

yesterday = datetime.now() - timedelta(days=1)
date = yesterday.strftime('%Y-%m-%d')

print 'Checking %s backup of %s:%s on %s ...' % (config, hostname, disk, date)


files = get_file_list()
print 'There are %s files.' % len(files)


random_file = choice(files)
output_path = path.join(prefix, random_file[len(disk) + 1:])
print 'Trying to extract %s ...' % random_file

p = Popen(['amrecover', config], stdin=PIPE, stdout=PIPE)
stdin = p.stdin

enter_line(stdin, 'lcd %s' % prefix)
enter_line(stdin, 'sethost %s' % hostname)
enter_line(stdin, 'setdisk %s' % disk)
enter_line(stdin, 'setdate %s' % date)
enter_line(stdin, 'add %s' % random_file)
enter_line(stdin, 'extract')
enter_line(stdin, 'Y')
enter_line(stdin, 'Y')
enter_line(stdin, 'exit')
p.communicate()


size = path.getsize(output_path)
assert size > 0
print 'File size is %s.' % size


p = Popen(['file', output_path], stdin=PIPE, stdout=PIPE)
output, error = p.communicate()
print output.strip()
assert error is None
assert p.returncode == 0


rmtree(prefix)
print 'Everything looks OK.'
