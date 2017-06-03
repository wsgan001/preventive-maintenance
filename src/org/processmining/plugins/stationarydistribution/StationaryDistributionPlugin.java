package org.processmining.plugins.stationarydistribution;
import org.deckfour.xes.model.XLog;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Find DTMC Stationary Distribution",
parameterLabels = { "Log", "Discrete Time Markov Chain" },
returnLabels = { "Stationary distribution" },
returnTypes = { StationaryDistribution.class },
userAccessible = true)
public class StationaryDistributionPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static StationaryDistribution findDistributionFromLog(
			  final PluginContext context,
			  final XLog log) {
		// Create a DTMC from the log
		DiscreteTimeMarkovChain dtmc = new DiscreteTimeMarkovChain(log);
		
		// Find the corresponding stationary distribution
		return new StationaryDistribution(dtmc);
	}
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 1 })
	public static StationaryDistribution findDistributionFromDtmc(
			  final PluginContext context,
			  final DiscreteTimeMarkovChain dtmc) {
		// Find the corresponding stationary distribution
		return new StationaryDistribution(dtmc);
	}
}
