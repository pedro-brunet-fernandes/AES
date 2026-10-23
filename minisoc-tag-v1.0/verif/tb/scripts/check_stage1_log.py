"""Fail make if UVM errors are present or the stage-1 completion is absent."""
import re
import sys
from pathlib import Path


def check(text):
    # Exige o resumo final para rejeitar logs truncados.
    errors = re.search(r"(?m)^\s*(?:UVM_ERROR|UVM_FATAL)\b(?!\s*:)", text)
    summaries = {
        severity: re.findall(rf"(?m)^\s*{severity}\s*:\s*(\d+)\s*$", text)
        for severity in ("UVM_ERROR", "UVM_FATAL")
    }
    if errors or any(not counts or any(int(n) for n in counts) for counts in summaries.values()):
        return False, "UVM error/fatal or missing clean report summary"
    if not re.search(r"(?m)^\s*UVM_INFO\b.*@.*\[STAGE1_PASS\]", text):
        return False, "Missing STAGE1_PASS completion marker"
    if re.search(r"(?mi)^\s*(?:Fatal:|Error-|\$fatal|.*Global TB watchdog timeout)", text):
        return False, "Simulator error/watchdog detected"
    return True, "Stage-1 clock/reset checks passed (not AES verification)"


def main():
    if len(sys.argv) != 2:
        print("Usage: check_stage1_log.py simulation.log", file=sys.stderr)
        return 2
    try:
        text = Path(sys.argv[1]).read_text(encoding="utf-8", errors="replace")
    except OSError as exc:
        print(exc, file=sys.stderr)
        return 1
    ok, message = check(text)
    print(message)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
