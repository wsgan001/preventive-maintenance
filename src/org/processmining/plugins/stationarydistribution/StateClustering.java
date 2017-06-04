package org.processmining.plugins.stationarydistribution;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
/**
 * Clusters states based on the signs of entries of the eigenvectors.
 * @author s147569
 */
public class StateClustering {
	private int clusterDepth;
	private Map<List<Sign>,List<String>> partition;
	
	public StateClustering(StationaryDistribution sd, int clusterDepth) {
		// Start with a clustering of depth zero.
		this.clusterDepth = 0;
		this.partition = new HashMap<List<Sign>,List<String>>();
		this.partition.put(new ArrayList<Sign>(), sd.getOrdering());
		
		// Keep deepening until the desired depth is reached.
		while (this.clusterDepth < clusterDepth) {
			Map<List<Sign>,List<String>> newPartition = new HashMap<List<Sign>,List<String>>();
			Set<Entry<List<Sign>, List<String>>> entrySet = this.partition.entrySet();
			for (Entry<List<Sign>, List<String>> entry : entrySet) {
				// Create signlists with one extra level of depth.
				ArrayList<Sign> plusList = new ArrayList<Sign>();
				ArrayList<Sign> minusList = new ArrayList<Sign>();
				// Deep copy because lists are passed by reference
				for (Sign s : entry.getKey()) {
					plusList.add(s);
					minusList.add(s);
				}
				plusList.add(Sign.PLUS);
				minusList.add(Sign.MINUS);
				
				// Partition
				List<String> plusStates = new ArrayList<String>();
				List<String> minusStates = new ArrayList<String>();
				for (String state : entry.getValue())
					if (sd.getEigenvectors()[this.clusterDepth].getEntry(state) > 0)
						plusStates.add(state);
					else
						minusStates.add(state);
				newPartition.put(plusList, plusStates);
				newPartition.put(minusList, minusStates);
			}
			
			// Increment
			this.partition = newPartition;
			this.clusterDepth ++;
		}
		
	}
	
	/**
	 * Gives the ordering of states that this clustering produced.
	 * The first cluster is the cluster of only positive eigenvector-entries
	 * The last cluster has only non-positive entries (which is surely empty since 
	 * the first eigenvector has positive entries only).
	 * @return The ordering that this clustering produced.
	 */
	public List<String> getOrdering() {
		List<String> result = new ArrayList<String>();
		for (int i=(int)Math.pow(2, clusterDepth)-1; i >= 0 ; i--) {
			result.addAll(partition.get(signsFromIndex(i)));
		}
		return result;
	}
	
	private List<Sign> signsFromIndex(int index) {
		List<Sign> result = new ArrayList<Sign>();
		for (int i = clusterDepth - 1; i >= 0; i--) {
			if (index >= Math.pow(2, i)) {
				result.add(Sign.PLUS);
				index -= Math.pow(2, i);
			} else {
				result.add(Sign.MINUS);
			}
		}
		return result;
	}
}
