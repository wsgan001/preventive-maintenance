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
@UIExportPlugin(description = "CSV-file (.csv)", extension = "csv")
public class TransitionTimeExportPlugin {
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
		    
		    // The biggest number of occurrences a transition has
		    int max = 0;
		    
		    // Print state names
		    String[] states = ctmc.keySet().toArray(new String[ctmc.size()]);
		    String statesLine = states[0]+"";
		    for (int s = 1; s < states.length; s++) {
		    	statesLine+=","+states[s];
		    	// Update max if necessary
		    	if (ctmc.getTransitionTimes().get(states[s]).size() > max)
		    		max = ctmc.getTransitionTimes().get(states[s]).size();
		    }
		    pwriter.println(statesLine);
		    
		    for (int i = 0; i < max; i++) {
	    		// Place NA if this event does not have an i'th occurrence
		    	String newLine = (ctmc.getTransitionTimes().get(states[0]).size() > i 
	    				? ctmc.getTransitionTimes().get(states[0]).get(i) 
	    						: "NA")+"";
		    	for (int s = 1; s < states.length; s++) {
		    		// Place NA if this event does not have an i'th occurrence
		    		newLine += ","+(ctmc.getTransitionTimes().get(states[s]).size() > i 
		    				? ctmc.getTransitionTimes().get(states[s]).get(i) 
		    						: "NA");
		    	}
		    	pwriter.println(newLine);
		    }
		    
		    
		    pwriter.close();
	  }
}
