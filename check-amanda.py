#!/usr/bin/env python

from subprocess import Popen, PIPE
from os import path, makedirs
from shutil import rmtree
from random import choice
from datetime import datetime, timedelta
import json
import re


def enter_line(stream, line):
    stream.write(line + '\n')


def process_lines(lines, dir_path, oldest, newest):

    files = []
    dirs = []
    pattern = re.compile('\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}')

    for line in lines:

        #print line
        if not pattern.match(line):
            # Ignore lines not containing amrecover ls output
            continue

        date_str, the_path = line.split(None, 1)
        # date_str is like '2013-10-21-07-49-40'
        the_date = datetime.strptime(date_str, '%Y-%m-%d-%H-%M-%S')
        assert oldest <= the_date <= newest

        if the_path == '.':
            # Ignore current directory
            continue

        abs_path = path.join(dir_path, the_path)
        if abs_path.endswith(path.sep):
            dirs.append(abs_path)
        else:
            #print abs_path
            files.append(abs_path)

    return dirs, files


def read_until(stream, delimiter):
    lines = []
    while True:
        line = str(stream.readline().strip())
        lines.append(line)
        if line == delimiter:
            return lines


def get_file_list(config, hostname, disk):

    pattern = re.compile('\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}')

    newest = datetime.today()
    # Plus one in case the backup for today hasn't run
    delta = {
        'daily': 5,
        'weekly': 35,
        'monthly': 150,
    }[config] + 1
    oldest = newest - timedelta(days=delta)

    p = Popen(['/usr/sbin/amrecover', config], stdin=PIPE, stdout=PIPE)
    stdin = p.stdin
    stdout = p.stdout

    enter_line(stdin, 'sethost %s' % hostname)
    enter_line(stdin, 'setdisk %s' % disk)
    enter_line(stdin, 'cd %s' % disk)
    read_until(stdout, disk)

    enter_line(stdin, 'ls')
    enter_line(stdin, 'cd %s' % disk)
    lines = read_until(stdout, disk)
    dirs, files = process_lines(lines, disk, oldest, newest)

    while dirs:

        # Only traverse one lucky directory
        directory = choice(dirs)
        enter_line(stdin, 'cd %s' % directory)
        enter_line(stdin, 'ls')
        enter_line(stdin, 'cd %s' % disk)

        lines = read_until(stdout, disk)
        dirs, new_files = process_lines(lines, directory, oldest, newest)
        files += new_files

    return files


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
    random_file = choice(files)

    print 'Trying to extract %s ...' % random_file
    test_extraction(config, hostname, disk, random_file[len(disk) + 1:])

    print 'Everything looks OK.'


if __name__ == '__main__':
    main()
