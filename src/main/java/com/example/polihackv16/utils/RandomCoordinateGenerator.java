package com.example.polihackv16.utils;

import org.springframework.stereotype.Component;

import java.util.Random;

@Component
public class RandomCoordinateGenerator {

    private static final double EARTH_RADIUS = 6371.0;
    private final Random random;

    public RandomCoordinateGenerator() {
        this.random = new Random();
    }

    /**
     * Generates a random coordinate within a circle.
     * 
     * @param latitude  The center latitude in degrees.
     * @param longitude The center longitude in degrees.
     * @param radius    The radius of the circle in meters.
     * @return A double array with [randomLatitude, randomLongitude].
     */
    public double[] generateRandomCoordinate(double latitude, double longitude, double radius) {
        double radiusKm = radius / 1000.0;
        double distanceKm = Math.sqrt(random.nextDouble()) * radiusKm;
        double angle = random.nextDouble() * 2 * Math.PI;

        double deltaLat = distanceKm / EARTH_RADIUS * (180 / Math.PI);
        double deltaLon = (distanceKm / EARTH_RADIUS * (180 / Math.PI)) / Math.cos(Math.toRadians(latitude));

        double randomLat = latitude + deltaLat * Math.sin(angle);
        double randomLon = longitude + deltaLon * Math.cos(angle);

        return new double[] { randomLat, randomLon };
    }
}
