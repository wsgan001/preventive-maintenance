package org.processmining.plugins.stationarydistribution;

import java.text.ParseException;
import java.util.ArrayList;

import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;

public class TraceLifetimes {
	private final Long[] lifetimes;
	
	public TraceLifetimes(XLog log) {
		ArrayList<Long> lifetimesList = new ArrayList<Long>();
		for (XTrace trace : log) {
			try {
				lifetimesList.add(
					XesAuxiliary.getTime(trace.get(trace.size()-1))
					- XesAuxiliary.getTime(trace.get(0)));
			} catch (ParseException e) {
				System.out.println("Parse exception");
				System.out.println(e.getMessage());
			}
		}
		lifetimes = lifetimesList.toArray(new Long[lifetimesList.size()]);
	}
	
	public Long[] getLifetimes() {
		return lifetimes;
	}
}
