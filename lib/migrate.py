#!/usr/bin/python3

import os
from subprocess import check_call
from sys import argv

while True:
    args = input('%s >> ' % os.getcwd()).strip()
    if (args.lower() == 'exit'):
        break
    args = args.split(' ')
    if args[0] == 'cd':
        os.chdir(args[1])
    elif args[0] == 'ls':
        print('\n' + '\n'.join(os.listdir(os.getcwd())) + '\n')
    else:
        try:
            os.rename(args[0], args[1])
            check_call('''
            . ~/.zsh_aliases
            strRepl \\# %s %s %s
            ''' % (args[0], args[1], argv[1]), shell=True, executable='/bin/bash')
        except Exception as e:
            print('\nTHERE IS NO FILE TO CHANGE. TYPO??\n')

