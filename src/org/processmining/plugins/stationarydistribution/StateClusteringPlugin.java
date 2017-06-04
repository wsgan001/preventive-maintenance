package org.processmining.plugins.stationarydistribution;

import java.util.List;

import org.processmining.contexts.uitopia.annotations.UITopiaVariant;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;
import org.processmining.framework.plugin.annotations.PluginVariant;

@Plugin(name = "Cluster States From DTMC Stationary Distribution",
parameterLabels = { "StationaryDistribution" },
returnLabels = { "State Clustered Stationary Distribution" },
returnTypes = { StationaryDistribution.class },
userAccessible = true)
public class StateClusteringPlugin {
	/**
	 * The amount of eigenvectors deep the clustering goes.
	 */
	public final static int clusterDepth = 4;
	
	@UITopiaVariant(affiliation = "TU/e",
            author = "Martijn M. Gösgens",
            email = "m.m.gosgens@student.tue.nl",
            uiLabel = UITopiaVariant.USEPLUGIN)
	@PluginVariant(requiredParameterLabels = { 0 })
	public static StationaryDistribution cluster(
			  final PluginContext context,
			  final StationaryDistribution sd) {
		// We're changing the object that is passed, this might result
		// in some reference bugs since the objects are passed by reference.
		StateClustering cluster = new StateClustering(sd,clusterDepth);
		List<String> newOrdering = cluster.getOrdering();
		sd.setOrdering(newOrdering);
		return sd;
	}
}
