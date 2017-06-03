package org.processmining.plugins.stationarydistribution;

import Jama.EigenvalueDecomposition;
import Jama.Matrix;

public class StationaryDistribution {
	private String[] states;
	private Eigenvector[] eigenvectors;
	
	/**
	 * Find the StationaryDistribution (or spectral decomposition) that corresponds to dtmc.
	 * @param dtmc
	 */
	public StationaryDistribution(DiscreteTimeMarkovChain dtmc) {
		// Keep states as an array
		states = dtmc.getStatesInOrder().toArray(new String[dtmc.size()]);
		
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
			double[] vector = new double[dim];
			for (int i = 0; i < vector.length; i ++) {
				vector[i] = ev.getV().get(i, r);
			}
			eigenvectors[r] = new Eigenvector(
					ev.getRealEigenvalues()[r],
					ev.getImagEigenvalues()[r],
					vector);
			// Normalising will be done in the Eigenvector class
		}
	}
	
	public String[] getStates() {
		return states;
	}
	
	public Eigenvector[] getEigenvectors() {
		return eigenvectors;
	}
}
