package org.processmining.plugins.stationarydistribution;

import java.text.ParseException;

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
	 * Gets the timestamp as long (number of milliseconds since 1970).
	 * @param event
	 * @return The number of milliseconds since 1970.
	 * @throws ParseException If the value cannot be parsed.
	 */
	public static Long getTime(XEvent event) throws ParseException {
		// Retrieve value and get the milliseconds since 1970.
		return ((XAttributeTimestamp)event.getAttributes().get("time:timestamp")).getValue().getTime();
	}
}
