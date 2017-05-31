package org.processmining.plugins.stationarydistribution;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.deckfour.xes.model.XAttributeLiteral;
import org.deckfour.xes.model.XEvent;
import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

import Jama.EigenvalueDecomposition;
import Jama.Matrix;

@Plugin(name = "Find DTMC Stationary Distribution From log",
parameterLabels = { "Log" },
returnLabels = { "Stationary distribution" },
returnTypes = { StationaryDistribution.class },
userAccessible = true)
public class StationaryDistributionPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static StationaryDistribution findDistribution(
			  final PluginContext context,
			  final XLog log) {
		// Use the value of attribute concept:name of the event as state name
		List<String> states = new ArrayList<String>();

		// The graph: Each 'state' is mapped to a mapping from outgoing states to the number
		// of times it occurred
		Map<String,Map<String,Double>> transitions = new HashMap<String,Map<String,Double>>();
			
		// Count transitions
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
						if (!transitions.containsKey(previous))
							transitions.put(previous, new HashMap<String,Double>());
	
						Map<String, Double> outgoing = transitions.get(previous);
	
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
			for (double weight : transitions.get(state).values())
				sum+=weight;
			for (String transition : transitions.get(state).keySet())
				transitions.get(state).put(transition, transitions.get(state).get(transition)/sum);
		}

		// Fill matrix
		double[][] indices = new double[states.size()][states.size()];
		for (String from : states) {
			for (String to : transitions.get(from).keySet()) {
				indices[states.indexOf(to)][states.indexOf(from)] = transitions.get(from).get(to);
			}
		}

		// Do linear algebra
		Matrix transitionMatrix = new Matrix(indices);
		EigenvalueDecomposition ev = transitionMatrix.eig();
		return new StationaryDistribution(states.toArray(new String[states.size()]),ev);
	}

	static String id(XEvent event) {
		return ((XAttributeLiteral)event.getAttributes().get("concept:name")).getValue();
	}

	static boolean isStart(XEvent event) {
		return "start".equals(((XAttributeLiteral)event.getAttributes().get("lifecycle:transition")).getValue());
	}
	
	static double[] getColumn(Matrix m, int c) {
		double[] vector = new double[m.getRowDimension()];
		for (int i = 0; i < m.getRowDimension(); i++) {
			vector[i] = m.get(i, c);
		}
		return vector;
	}
}
