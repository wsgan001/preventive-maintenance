package org.processmining.plugins.stationarydistribution;

import java.util.ArrayList;

import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;

public class TraceLifetimes {
	private final Long[] lifetimes;
	
	public TraceLifetimes(XLog log) {
		ArrayList<Long> lifetimesList = new ArrayList<Long>();
		for (XTrace trace : log) {
			lifetimesList.add(
				XesAuxiliary.getTime(trace.get(trace.size()-1))
				- XesAuxiliary.getTime(trace.get(0)));
		}
		lifetimes = lifetimesList.toArray(new Long[lifetimesList.size()]);
	}
	
	public Long[] getLifetimes() {
		return lifetimes;
	}
}
