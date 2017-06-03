package org.processmining.plugins.stationarydistribution;

import org.deckfour.xes.model.XLog;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Find Trace Lifetimes From XLog",
parameterLabels = { "Log" },
returnLabels = { "Trace Lifetimes" },
returnTypes = { TraceLifetimes.class },
userAccessible = true)
public class TraceLifetimesPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static TraceLifetimes findDtmc(
			  final PluginContext context,
			  final XLog log) {
		// Create a DTMC from the log
		return new TraceLifetimes(log);
	}
}
