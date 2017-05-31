package org.processmining.plugins.stationarydistribution;

import Jama.EigenvalueDecomposition;

public class StationaryDistribution {
	private String[] states;
	private Eigenvector[] eigenvectors;
	
	public StationaryDistribution(String[] stateNames, EigenvalueDecomposition ev) {
		states = stateNames;
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
