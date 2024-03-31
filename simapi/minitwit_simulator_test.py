# test_file_lines.py
import pytest
import sys

# Define the maximum number of lines allowed in the file
MAX_LINES_THRESHOLD = 10


# Define the fixture to open the file
@pytest.fixture
def log_file():
    file_name = sys.argv[2]
    with open(file_name) as file:
        yield file


def test_file_line_count(log_file):
    # Read all lines from the file
    lines = log_file.readlines()

    # Assert that the number of lines is less than the threshold
    assert (
        len(lines) < 1
    ), f"Number of lines exceeds the threshold of {MAX_LINES_THRESHOLD}"


def test_no_tweet_errors(log_file):
    # Read all lines from the file
    lines = log_file.readlines()

    # Check each line for the presence of "tweet"
    for line in lines:
        assert "tweet" not in line, "Found a line containing 'tweet'"


def test_no_register_errors(log_file):
    # Read all lines from the file
    lines = log_file.readlines()

    # Check each line for the presence of "tweet"
    for line in lines:
        assert "register" not in line, "Found a line containing 'register'"


def test_no_follow_errors(log_file):
    # Read all lines from the file
    lines = log_file.readlines()

    # Check each line for the presence of "tweet"
    for line in lines:
        assert "follow" not in line, "Found a line containing 'follow'"


def test_no_unfollow_errors(log_file):
    # Read all lines from the file
    lines = log_file.readlines()

    # Check each line for the presence of "tweet"
    for line in lines:
        assert "unfollow" not in line, "Found a line containing 'unfollow'"
