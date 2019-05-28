#ifndef TESTBENCH_H
#define TESTBENCH_H

#include <verilated_vcd_c.h>

template<class MODULE> class TESTBENCH {

public:
	unsigned long m_tickcount;
	MODULE *m_core;
	VerilatedVcdC *m_trace;

	TESTBENCH(void) {
		m_core = new Vm68k_tb;
		m_tickcount = 0l;
		Verilated::traceEverOn(true);
	}

	virtual ~TESTBENCH(void) {
		closetrace();
		delete m_core;
		m_core = NULL;
	}

	virtual void opentrace(const char *vcdname) {
		if (!m_trace) {
			m_trace = new VerilatedVcdC;
			m_core->trace(m_trace, 99);
			m_trace->open(vcdname);
		}
	}

	virtual void closetrace(void) {
		if (m_trace) {
			m_trace->close();
			delete m_trace;
			m_trace = NULL;
		}
	}

	virtual void reset(void) {
		m_core->rst = 1;
		this->tick();
		m_core->rst = 0;
	}

	virtual void tick(void) {
		m_tickcount++;

		m_core->eval();
		if (m_trace) m_trace->dump((vluint64_t)(10*m_tickcount-2));

		m_core->clk = 1;
		m_core->eval();
		if (m_trace) m_trace->dump((vluint64_t)(10*m_tickcount));

		m_core->clk = 0;
		m_core->eval();
		if (m_trace) {
			m_trace->dump((vluint64_t)(10*m_tickcount+5));
			m_trace->flush();
		}
	}

	virtual bool done(void) {
		return Verilated::gotFinish();
	}
};

#endif /* TESTBENCH_H */
