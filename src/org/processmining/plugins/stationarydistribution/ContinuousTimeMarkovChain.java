package org.processmining.plugins.stationarydistribution;

import static org.processmining.plugins.stationarydistribution.XesAuxiliary.getTime;
import static org.processmining.plugins.stationarydistribution.XesAuxiliary.id;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.deckfour.xes.model.XEvent;
import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;

public class ContinuousTimeMarkovChain implements Map<String, Map<String, Double>>{
	private Map<String,Map<String,Double>> ctmc;
	private Map<String,List<Long>> transitionTimes;
	
	public ContinuousTimeMarkovChain(XLog log) {
		// Get the discrete chain
		DiscreteTimeMarkovChain dtmc = new DiscreteTimeMarkovChain(log);
		
		// Initialise ctmc
		ctmc = new HashMap<String,Map<String,Double>>();
		
		// Remove transitions to self
		for (String state : dtmc.keySet()) {
			if (dtmc.get(state).containsKey(state)) {
				double divider = 1-dtmc.get(state).get(state);
				// Remove
				dtmc.get(state).remove(state);
				// Make sure the outgoing probabilities sum up to 1
				for (String out : dtmc.get(state).keySet())
					dtmc.get(state).put(out, dtmc.get(state).get(out)/divider);
			}
		}
		
		transitionTimes = new HashMap<String, List<Long>>();
		
		// Add the states to the maps
		for (String state : dtmc.keySet()) {
			transitionTimes.put(state, new ArrayList<Long>());
			ctmc.put(state, new HashMap<String,Double>());
		}
		
		// Gather the times the ctmc stayed in each state.
		for (XTrace trace : log) {
			String state = null;
			XEvent lastEvent = null;
			Long time = null;
			for (XEvent event : trace) {
				// First transition
				if (time == null) {
					time = getTime(event);
					state = id(event);
				}
				
				// New transition
				if(!id(event).equals(state)) {
					transitionTimes.get(state).add(getTime(lastEvent)-time);
					time = getTime(event);
					state = id(event);
				}
				lastEvent = event;
			}
		}
		
		// Find total transition intensity
		Map<String, Double> totalLambdas = new HashMap<String,Double>();
		for (Entry<String, List<Long>> entry : transitionTimes.entrySet()) {
			double sum = 0;
			for (Long time : entry.getValue()) {
				sum += time;
			}
			totalLambdas.put(entry.getKey(), entry.getValue().size()/sum);
		}
		
		// Set transition intensities
		for (String from : dtmc.keySet()) {
			// Set outgoing
			for (String to : dtmc.get(from).keySet()) {
				if (!from.equals(to)) {
					ctmc.get(from).put(to, totalLambdas.get(from)*dtmc.get(from).get(to));
				}
			}
			// Set intensity to self
			ctmc.get(from).put(from, -totalLambdas.get(from));
		}
	}

	@Override
	public int size() {
		return ctmc.size();
	}

	@Override
	public boolean isEmpty() {
		return ctmc.isEmpty();
	}

	@Override
	public boolean containsKey(Object key) {
		return ctmc.containsKey(key);
	}

	@Override
	public boolean containsValue(Object value) {
		return ctmc.containsValue(value);
	}

	@Override
	public Map<String, Double> get(Object key) {
		return ctmc.get(key);
	}

	@Override
	public Map<String, Double> put(String key, Map<String, Double> value) {
		return ctmc.put(key, value);
	}

	@Override
	public Map<String, Double> remove(Object key) {
		return ctmc.remove(key);
	}

	@Override
	public void putAll(Map<? extends String, ? extends Map<String, Double>> m) {
		ctmc.putAll(m);
	}

	@Override
	public void clear() {
		ctmc.clear();
	}

	@Override
	public Set<String> keySet() {
		return ctmc.keySet();
	}

	@Override
	public Collection<Map<String, Double>> values() {
		return ctmc.values();
	}

	@Override
	public Set<java.util.Map.Entry<String, Map<String, Double>>> entrySet() {
		return ctmc.entrySet();
	}
	
	public Map<String,List<Long>> getTransitionTimes() {
		return transitionTimes;
	}
}
