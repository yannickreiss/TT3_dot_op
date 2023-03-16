import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):
  dut._log.info("start")

  # Testcases
  dut.INPUT.value = 1
  await Timer(1, units="ms")
  assert dut.OUTPUT.value == 0
