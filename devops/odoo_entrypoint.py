"""Handle odoo service

    Usage:
        odoooi start
        odoooi upgrade
"""

import docopt
import subprocess


def main():
    args = docopt.docopt(__doc__)
    # command_args = args['--type'] or 'normal'
    if bool(args.get("start", True)):
        run_process()
    elif bool(args.get("upgrade", True)):
        upgrade_process()
    # elif bool(args.get("loaddata", True)):
    #     loaddata_process()


def run_process():
    cmd = """
        ~/odoo-server/odoo-bin --config /etc/odoo-server.conf --addons-path /home/odoo/odoo-server/addons,/home/odoo/custom/addons
    """
    subprocess.run(cmd, shell=True, universal_newlines=True, check=True)


# Need custom for dynamic args module name
def upgrade_process():
    cmd = """
        ~/odoo-server/odoo-bin --config /etc/odoo-server.conf --addons-path /home/odoo/odoo-server/addons,/home/odoo/custom/addons -u ucenreg
    """
    subprocess.run(cmd, shell=True, universal_newlines=True, check=True)


# def loaddata_process():
#     cmd = """
#         python manage.py makemigrations &&
#         python manage.py migrate &&
#         python manage.py loaddata
#     """
#     subprocess.run(cmd, shell=True, universal_newlines=True, check=True)


if __name__ == "__main__":
    main()
