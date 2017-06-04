package org.processmining.plugins.stationarydistribution;
import org.deckfour.xes.model.XLog;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Find CTMC From XLog",
parameterLabels = { "Log" },
returnLabels = { "Continuous Time Markov Chain" },
returnTypes = { ContinuousTimeMarkovChain.class },
userAccessible = true)
public class ContinuousTimeMarkovChainPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static ContinuousTimeMarkovChain findCtmc(
			  final PluginContext context,
			  final XLog log) {
		// Create a CTMC from the log
		ContinuousTimeMarkovChain ctmc = new ContinuousTimeMarkovChain(log);
		return ctmc;
	}
}