package org.processmining.plugins.stationarydistribution;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.deckfour.xes.model.XAttributeLiteral;
import org.deckfour.xes.model.XEvent;
import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;

/**
 * This class encapsulates Map<String,Map<String,Double>>. It is created to be able to use this as input for other plugins
 * and to group auxiliary functions.
 * @author s147569
 */
public class DiscreteTimeMarkovChain implements Map<String,Map<String,Double>> {
	// The graph: Each 'state' is mapped to a mapping from outgoing states to the number
	// of times it occurred
	private Map<String, Map<String,Double>> dtmc = new HashMap<String,Map<String,Double>>();
	
	// The keys/states, can be reordered for clustering purposes.
	private ArrayList<String> states = new ArrayList<String>();
	
	/* 
	 * Implementation of inherited methods from Map<String,Map<String,Double>>.
	 */
	@Override
	public int size() {
		return dtmc.size();
	}

	@Override
	public boolean isEmpty() {
		return dtmc.isEmpty();
	}

	@Override
	public boolean containsKey(Object key) {
		return dtmc.containsKey(key);
	}

	@Override
	public boolean containsValue(Object value) {
		return dtmc.containsValue(value);
	}

	@Override
	public Map<String, Double> get(Object key) {
		return dtmc.get(key);
	}

	@Override
	public Map<String, Double> put(String key, Map<String, Double> value) {
		return dtmc.put(key, value);
	}

	@Override
	public Map<String, Double> remove(Object key) {
		return dtmc.remove(key);
	}

	@Override
	public void putAll(Map<? extends String, ? extends Map<String, Double>> m) {
		dtmc.putAll(m);
	}

	@Override
	public void clear() {
		dtmc.clear();
	}

	@Override
	public Set<String> keySet() {
		return dtmc.keySet();
	}

	@Override
	public Collection<Map<String, Double>> values() {
		return dtmc.values();
	}

	@Override
	public Set<Entry<String, Map<String, Double>>> entrySet() {
		return dtmc.entrySet();
	}
	
	/**
	 * Returns the state in their current ordering.
	 * @return The states in their current order.
	 */
	public List<String> getStatesInOrder() {
		return states;
	}
	
	/*
	 * This constructor creates the DTMC from the log
	 */
	public DiscreteTimeMarkovChain(XLog log) {
		for (XTrace trace : log) {
			String previous = null;
			for (XEvent event : trace) {
				if (isStart(event)) {
					String eventID = id(event);
					if (!states.contains(eventID))
						states.add(eventID);
	
					// If it is not the first event in the trace
					if (previous != null) {
						// Make sure the previous event has a hashmap
						if (!dtmc.containsKey(previous))
							dtmc.put(previous, new HashMap<String,Double>());
	
						Map<String, Double> outgoing = dtmc.get(previous);
	
						// Make sure there is an 'edge' for this transition
						if (!outgoing.containsKey(eventID))
							outgoing.put(eventID, 0d);
	
						// Increment
						outgoing.put(eventID, outgoing.get(eventID)+1);
					}
					previous = eventID;
				}
			}
		}

		// normalize:
		for (String state : states) {
			double sum = 0;
			for (double weight : dtmc.get(state).values())
				sum+=weight;
			for (String transition : dtmc.get(state).keySet())
				dtmc.get(state).put(transition, dtmc.get(state).get(transition)/sum);
		}

	}

	/* Functions for retrieving attributes: */
	private static String id(XEvent event) {
		return ((XAttributeLiteral)event.getAttributes().get("concept:name")).getValue();
	}

	private static boolean isStart(XEvent event) {
		return "start".equals(((XAttributeLiteral)event.getAttributes().get("lifecycle:transition")).getValue());
	}

}
