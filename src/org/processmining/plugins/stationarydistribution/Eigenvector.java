package org.processmining.plugins.stationarydistribution;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

public class Eigenvector {
	//private double[] vector;
	private Map<String, Double> vector;
	private double eigenvalueReal;
	private double eigenvalueImaginary;
	
	public Eigenvector (double real, double imaginary, Map<String,Double> v) {
		eigenvalueReal = real;
		eigenvalueImaginary = imaginary;
		
		// Normalise, since all eigenvectors except the one corresponding to eigenvalue 1 sum up to zero,
		// we normalise such that the sum of their absolute values equal 1
		double sum = 0;
		for (double x : v.values())
			sum += Math.abs(x);
		
		// Make sure the one entry is positive so that the first eigenvector is positive
		sum *=Math.signum((double)v.values().toArray()[0]);
		
		vector = new HashMap<String, Double>();
		for (Entry<String,Double> entry : v.entrySet()) {
			vector.put(entry.getKey(), entry.getValue()/sum);
		}
	}
	
	public double getEntry(String s) {
		return vector.get(s);
	}
	
	public double getEigenvalueReal() {
		return eigenvalueReal;
	}
	
	public double getEigenvalueImaginary() {
		return eigenvalueImaginary;
	}
}
