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

@Plugin(name = "Trace Lifetimes Exporter",
parameterLabels = { "Trace Lifetimes", "File" },
returnLabels = { },
returnTypes = { },
userAccessible = true)
@UIExportPlugin(description = "CSV-file (.csv)", extension = "csv")
public class TraceLifetimesExportPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0, 1 })
	public void export(
			PluginContext context,
            TraceLifetimes tl,
            File file) throws IOException {
		    FileWriter writer = new FileWriter(file);
		    PrintWriter pwriter = new PrintWriter(writer);
		    pwriter.println("Lifetime");
		    // Print each lifetime on a new line
		    for (Long lifetime : tl.getLifetimes())
		    	pwriter.println(lifetime);
		    
		    pwriter.close();
	  }
	  
	  
}
