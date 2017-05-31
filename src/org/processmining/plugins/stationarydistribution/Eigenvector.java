package org.processmining.plugins.stationarydistribution;


public class Eigenvector {
	private double[] vector;
	private double eigenvalueReal;
	private double eigenvalueImaginary;
	
	public Eigenvector (double real, double imaginary, double[] v) {
		eigenvalueReal = real;
		eigenvalueImaginary = imaginary;
		
		// Normalise, since all eigenvectors except the one corresponding to eigenvalue 1 sum up to zero,
		// we normalise such that the sum of their absolute values equal 1
		double sum = 0;
		for (double x : v)
			sum += Math.abs(x);
		
		// Make sure the first entry is positive so that the first eigenvector is positive
		int index = 0;
		while (index < v.length && (v[index] == -0.0 || v[index]==0.0)) {
			index ++;
		}
		if (index != v.length && v[index]!=-0.0 && v[index] !=0.0) {
			sum *= Math.signum(v[index]);
		}
		
		vector = new double[v.length];
		for (int i = 0; i <v.length; i++)
			vector[i] = v[i]/sum;
	}
	
	public double[] getVector() {
		return vector;
	}
	
	public double getEigenvalueReal() {
		return eigenvalueReal;
	}
	
	public double getEigenvalueImaginary() {
		return eigenvalueImaginary;
	}
}
