from scripts.deploy import deploy
from scripts.lib import pyprint, getAccount
from brownie import (
    accounts,
    config,
    Ostra
)


# Unit Test Section
# Use --disable-warnings to disable Brownie Main Warnings (Block Height & _owner Namespace Collision)

# Print with PyTest:
# with capsys.disabled():
#     pyprint(msg, title) (Title is Optional)


def test_init(capsys):
    pass
