"""Host-side checks of failure propagation; no HDL simulation is claimed."""
import unittest
from check_stage1_log import check

GOOD = """UVM_INFO @ 20000: uvm_test_top [STAGE1_PASS] clock=38 reset_pulses=1
UVM_ERROR : 0
UVM_FATAL : 0
"""


class CheckLogTests(unittest.TestCase):
    def test_complete_clean_run(self):
        self.assertTrue(check(GOOD)[0])

    def test_uvm_error_even_when_simulator_exits_zero(self):
        self.assertFalse(check(GOOD.replace("UVM_ERROR : 0", "UVM_ERROR : 1"))[0])

    def test_error_line_before_clean_summary(self):
        self.assertFalse(check("UVM_ERROR @ 100: x [BAD] mismatch\n" + GOOD)[0])

    def test_vcs_includes_source_location(self):
        self.assertTrue(check(GOOD.replace("UVM_INFO @", "UVM_INFO tests/minisoc_base_test.sv(30) @"))[0])
        self.assertFalse(check("UVM_ERROR env/checker.sv(40) @ 100: x [BAD] mismatch\n" + GOOD)[0])

    def test_truncated_log(self):
        self.assertFalse(check(GOOD.split("UVM_ERROR")[0])[0])

    def test_empty_or_unimplemented_test(self):
        self.assertFalse(check("UVM_ERROR : 0\nUVM_FATAL : 0\n")[0])

    def test_watchdog_after_pass(self):
        self.assertFalse(check(GOOD + "Fatal: Global TB watchdog timeout\n")[0])


if __name__ == "__main__":
    unittest.main()
