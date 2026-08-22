"""CLI mediator. Reads --id / --from / --on from argv only."""

import argparse
import json
import sys


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--id")
    parser.add_argument("--from", dest="from_id")
    parser.add_argument("--on")
    return parser.parse_args(argv)


def run(args):
    if args.id or (args.from_id and args.on):
        return {
            "mode": "auto",
            "id": args.id,
            "from": args.from_id,
            "on": args.on,
        }
    return {"mode": "idle", "reason": "no run id or from/on"}


def main(argv=None):
    print(json.dumps(run(parse_args(argv))))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
