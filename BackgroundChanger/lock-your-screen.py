import os
import re

'''
export PS1='C:${PWD//\//\\\}>'
"echo "sleep 0.1" >> ~/.bashrc" in bashrc - gradually start loading slower
alias ls='ls | rev'
pacat -p somefile.wav --file-format=wav
'''


class ShellSettingsTweaker(object):
    '''
    Abstract class containing main logic. Inherit and set config files for each shell respectively
    '''
    def __init__(self, shell_path):
        self.__shell_path = shell_path
        '''
        List containing all config files for the current shell.
        Logic will be spread across all to be more annoying and more obscure
        '''
        self.config_files = []

    def tweak_settings(self):
        if not self.config_files:
            raise Exception('No config files are defined!')


class BashShellSettingsTweaker(ShellSettingsTweaker):
    config_files = ['~/.bashrc']


def get_user_shell(user_id) -> str:
    passwd_content = open('/etc/passwd', 'r').read()
    # Shell string is the last column in the /etc/passwd match
    shell = re.search(str(user_id) + '.*', passwd_content).group(0).split(':')[-1]
    return shell


def main() -> None:
    print(get_user_shell(os.getuid()))


if __name__ == "__main__":
    main()

