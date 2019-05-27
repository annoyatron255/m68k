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

	while(!tb->done()) {
		tb->tick();

		if (tb->m_core->RX_DV) {
			//addch(tb->m_core->RX_data);
			putchar(tb->m_core->RX_data);
			refresh();
		}

		if (tb->m_core->TX_active) {
			tb->m_core->TX_start = 0;
		} else {
			int c = getch();
			if (c != ERR) {
				tb->m_core->TX_data = c;
				tb->m_core->TX_start = 1;
			}	
		}
	}
	tb->done();
	endwin();
	return 0;
}
