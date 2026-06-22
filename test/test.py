# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


CMD_LOAD_A = 1
CMD_LOAD_B = 2
CMD_LOAD_MODE = 3
CMD_LOAD_BANK = 4
CMD_LOAD_CFG = 5

MODE_ADD = 0
MODE_MUL_LO = 1
MODE_DIV_Q = 2
MODE_MUL_HI = 3


async def load_reg(dut, cmd, value):
    dut.ui_in.value = value & 0xFF
    dut.uio_in.value = cmd & 0x07
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 1)


async def set_operands(dut, a, b):
    await load_reg(dut, CMD_LOAD_A, a)
    await load_reg(dut, CMD_LOAD_B, b)


async def wait_divider_pipe(dut):
    await ClockCycles(dut.clk, 5)


def uo(dut):
    return dut.uo_out.value.to_unsigned()


def status_bit(dut):
    return (dut.uio_out.value.to_unsigned() >> 3) & 1


@cocotb.test()
async def test_arith_lab_cfg_status_and_results(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    assert dut.uio_oe.value.to_unsigned() == 0xF8

    await load_reg(dut, CMD_LOAD_BANK, 0)
    await load_reg(dut, CMD_LOAD_MODE, MODE_ADD)

    dut._log.info("ADD unsigned carry through cfg[0]=0")
    await load_reg(dut, CMD_LOAD_CFG, 0)
    await set_operands(dut, 100, 50)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 150
    assert status_bit(dut) == 0

    await set_operands(dut, 200, 100)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 44
    assert status_bit(dut) == 1

    dut._log.info("ADD signed overflow through cfg[0]=1")
    await load_reg(dut, CMD_LOAD_CFG, 1)
    await set_operands(dut, 50, 40)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 90
    assert status_bit(dut) == 0

    await set_operands(dut, 120, 10)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 130
    assert status_bit(dut) == 1

    dut._log.info("MUL low/high byte and high-byte-nonzero status")
    await load_reg(dut, CMD_LOAD_MODE, MODE_MUL_LO)
    await set_operands(dut, 10, 5)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 50
    assert status_bit(dut) == 0

    await set_operands(dut, 100, 10)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 0xE8
    assert status_bit(dut) == 1

    await load_reg(dut, CMD_LOAD_MODE, MODE_MUL_HI)
    await ClockCycles(dut.clk, 1)
    assert uo(dut) == 0x03
    assert status_bit(dut) == 1

    dut._log.info("DIV quotient and divide-by-zero status")
    await load_reg(dut, CMD_LOAD_MODE, MODE_DIV_Q)
    await set_operands(dut, 40, 2)
    await wait_divider_pipe(dut)
    assert uo(dut) == 20
    assert status_bit(dut) == 0

    await set_operands(dut, 40, 0)
    await wait_divider_pipe(dut)
    assert uo(dut) == 0
    assert status_bit(dut) == 1
