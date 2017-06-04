package org.processmining.plugins.stationarydistribution;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.RoundingMode;
import java.text.DecimalFormat;

import org.processmining.contexts.uitopia.annotations.UIExportPlugin;
import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Stationary Distribution Exporter",
parameterLabels = { "Stationary Distribution", "File" },
returnLabels = { },
returnTypes = { },
userAccessible = true)
@UIExportPlugin(description = "Regular txt file (.txt)", extension = "txt")
public class StationaryDistributionExportPlugin {
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0, 1 })
	public void export(
			PluginContext context,
            StationaryDistribution sd,
            File file) throws IOException {
		    FileWriter writer = new FileWriter(file);
		    PrintWriter pwriter = new PrintWriter(writer);
	    // For rounding
	    DecimalFormat df = new DecimalFormat("##.##");
	    df.setRoundingMode(RoundingMode.HALF_UP);
	    
	    
	    // Print eigenvalues on first row
	    String previousNumber = "";
	    for (Eigenvector ev : sd.getEigenvectors()) {
	    	// Add tabs
	    	int l = previousNumber.length();
	    	while (l<12) {
	    		pwriter.print("\t");
	    		l+=4;
	    	}
	    	
	    	String complexNumber = df.format(ev.getEigenvalueReal())
	    			+(ev.getEigenvalueImaginary() == 0.0 ? "" : (ev.getEigenvalueImaginary() > 0 ? "+" : "")
					+df.format(ev.getEigenvalueImaginary())+"i");
	    	pwriter.print(complexNumber);
	    	previousNumber = complexNumber;
	    }
	    pwriter.println();
	    
	    // Print eigenvectors in matrix
	    for (int i = 0; i < sd.getOrdering().size(); i++) {
	    	pwriter.print(sd.getOrdering().get(i));
	    	previousNumber = "";
	    	for (Eigenvector ev : sd.getEigenvectors()) {
	    		int l = previousNumber.length();
	    		while (l<12) {
	    			pwriter.print("\t");
	    			l+=4;
	    		}
	    		previousNumber = df.format(ev.getEntry(sd.getOrdering().get(i)));
	    		pwriter.print(previousNumber);
	    	}
	    	pwriter.println();
	    }
	    pwriter.close();
	}
}
