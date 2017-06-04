package org.processmining.plugins.stationarydistribution;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import org.processmining.contexts.uitopia.annotations.UIExportPlugin;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Continuous Time Markov Chain Exporter",
parameterLabels = { "Continuous Time Markov Chain", "File" },
returnLabels = { },
returnTypes = { },
userAccessible = true)
@UIExportPlugin(description = "Regular txt file (.txt)", extension = "txt")
public class ContinuousTimeMarkovChainExportPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0, 1 })
	public void export(
			PluginContext context,
			ContinuousTimeMarkovChain ctmc,
            File file) throws IOException {
		    FileWriter writer = new FileWriter(file);
		    PrintWriter pwriter = new PrintWriter(writer);
		    
		    
		    
		    
		    pwriter.close();
	  }
}
