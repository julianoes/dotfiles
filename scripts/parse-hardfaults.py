#!/usr/bin/env python3

import sys

def main(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            words = content.split()
            target_words = [word for word in words if (word.startswith('0x08') or word.startswith('08'))]

            for word in target_words:
                prefix = '0x' if not word.startswith('0x') else ''
                print(f"-ex 'info line *{prefix}{word}'", end=' ')

    except FileNotFoundError:
        print(f"The file {file_path} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: parse-hardfaults.py <hardfault file>")
    else:
        main(sys.argv[1])

