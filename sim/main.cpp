#include <iostream>
#include "Vm68k_tb.h"
#include "verilated.h"
#include "testbench.h"

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	
	TESTBENCH<Vm68k_tb> *tb = new TESTBENCH<Vm68k_tb>();

	tb->opentrace("dump.vcd");
	tb->reset();

	bool last_DTACKn = 1;
	tb->m_core->TX_data = '?';
	while(!tb->done()) {
		tb->tick();
		if (last_DTACKn && !tb->m_core->m68k_tb__DOT__DTACKn)
			std::cout << (char)tb->m_core->RX_data;
		last_DTACKn = tb->m_core->m68k_tb__DOT__DTACKn;
	}
	tb->done();
	return 0;
}
