package org.processmining.plugins.stationarydistribution;
import org.deckfour.xes.model.XLog;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Find DTMC From XLog",
parameterLabels = { "Log" },
returnLabels = { "Discrete Time Markov Chain" },
returnTypes = { DiscreteTimeMarkovChain.class },
userAccessible = true)
public class DiscreteTimeMarkovChainPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static DiscreteTimeMarkovChain findDtmc(
			  final PluginContext context,
			  final XLog log) {
		// Create a DTMC from the log
		return new DiscreteTimeMarkovChain(log);
	}
}
