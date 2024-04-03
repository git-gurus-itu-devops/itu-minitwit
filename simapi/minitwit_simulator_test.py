# test_file_lines.py
import pytest
import sys

MAX_LINES_THRESHOLD = 10


@pytest.fixture
def log_file():
    file_name = sys.argv[2]
    with open(file_name) as file:
        yield file


def test_file_line_count(log_file):
    lines = log_file.readlines()

    assert (
        len(lines) < MAX_LINES_THRESHOLD
    ), f"Number of lines exceeds the threshold of {MAX_LINES_THRESHOLD}"


def test_no_tweet_errors(log_file):
    lines = log_file.readlines()

    for line in lines:
        assert "tweet" not in line, "Found a line containing 'tweet'"


def test_no_register_errors(log_file):
    lines = log_file.readlines()

    for line in lines:
        assert "register" not in line, "Found a line containing 'register'"


def test_no_follow_errors(log_file):
    lines = log_file.readlines()

    for line in lines:
        assert "follow" not in line, "Found a line containing 'follow'"


def test_no_unfollow_errors(log_file):
    lines = log_file.readlines()

    for line in lines:
        assert "unfollow" not in line, "Found a line containing 'unfollow'"
