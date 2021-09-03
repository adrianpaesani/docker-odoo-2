from setuptools import setup

setup(
    name="odoo_entrypoint",
    entry_points={
        "console_scripts": [
            "odoooi = odoo_entrypoint:main",
        ],
    },
)
