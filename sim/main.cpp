#include <iostream>
#include <ncurses.h>
#include "Vm68k_tb.h"
#include "verilated.h"
#include "testbench.h"

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	
	TESTBENCH<Vm68k_tb> *tb = new TESTBENCH<Vm68k_tb>();

	//tb->opentrace("dump.vcd");
	tb->reset();

	initscr();
	cbreak();
	noecho();
	nodelay(stdscr, TRUE);

	bool last_DTACKn = 1;
	tb->m_core->TX_data = 'H';
	while(!tb->done()) {
		tb->tick();

		if (last_DTACKn && !tb->m_core->m68k_tb__DOT__DTACKn) {
			std::cout << (char)tb->m_core->RX_data;
			refresh();
		}
		last_DTACKn = tb->m_core->m68k_tb__DOT__DTACKn;

		char c = getch();
		if (c != ERR) {
			tb->m_core->TX_data = c;
			tb->m_core->TXE = 0;
		} else if (tb->m_core->TX_read) {
			tb->m_core->TXE = 1;
		}
	}
	tb->done();
	endwin();
	return 0;
}
