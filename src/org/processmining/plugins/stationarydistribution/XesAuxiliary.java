package org.processmining.plugins.stationarydistribution;

import org.deckfour.xes.model.XAttributeLiteral;
import org.deckfour.xes.model.XAttributeTimestamp;
import org.deckfour.xes.model.XEvent;

public class XesAuxiliary {
	/**
	 * Retrieves the id of the event
	 * @param event
	 * @return The id of the event.
	 */
	public static String id(XEvent event) {
		return ((XAttributeLiteral)event.getAttributes().get("concept:name")).getValue();
	}

	/**
	 * Sees whether this event is the start of a transition.
	 * @param event
	 * @return Whether this event is the start of a transition
	 */
	public static boolean isStart(XEvent event) {
		return "start".equals(((XAttributeLiteral)event.getAttributes().get("lifecycle:transition")).getValue());
	}

	/**
	 * Gets the timestamp as long (number of seconds since 1970).
	 * @param event
	 * @return The number of seconds since 1970.
	 */
	public static Long getTime(XEvent event) {
		// Retrieve value and get the seconds since 1970.
		return ((XAttributeTimestamp)event.getAttributes().get("time:timestamp")).getValue().getTime()/1000;
	}
}
