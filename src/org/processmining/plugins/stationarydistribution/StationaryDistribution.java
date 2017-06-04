package org.processmining.plugins.stationarydistribution;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Jama.EigenvalueDecomposition;
import Jama.Matrix;

public class StationaryDistribution {
	private List<String> ordering;
	private Eigenvector[] eigenvectors;
	
	/**
	 * Find the StationaryDistribution (or spectral decomposition) that corresponds to dtmc.
	 * @param dtmc
	 */
	public StationaryDistribution(DiscreteTimeMarkovChain dtmc) {
		// Keep states as an array
		ordering = dtmc.getStatesInOrder();
		
		// Fill matrix
		double[][] indices = new double[dtmc.size()][dtmc.size()];
		for (String from : dtmc.keySet()) {
			for (String to : dtmc.get(from).keySet()) {
				indices[dtmc.getStatesInOrder().indexOf(to)][dtmc.getStatesInOrder().indexOf(from)] = dtmc.get(from).get(to);
			}
		}

		// Do linear algebra
		Matrix transitionMatrix = new Matrix(indices);
		EigenvalueDecomposition ev = transitionMatrix.eig();
		
		int dim = ev.getV().getRowDimension();
		eigenvectors = new Eigenvector[dim];
		for (int r = 0; r < dim; r++) {
			// Retrieve the corresponding eigenvector
			Map<String,Double> vector = new HashMap<String,Double>();
			for (int i = 0; i < dim; i ++) {
				vector.put(ordering.get(i),ev.getV().get(i, r));
			}
			eigenvectors[r] = new Eigenvector(
					ev.getRealEigenvalues()[r],
					ev.getImagEigenvalues()[r],
					vector);
			// Normalising will be done in the Eigenvector class
		}
	}
	
	public void setOrdering(List<String> ordering) {
		this.ordering = ordering;
	}
	
	public List<String> getOrdering() {
		return ordering;
	}
	
	public Eigenvector[] getEigenvectors() {
		return eigenvectors;
	}
}
