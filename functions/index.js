/**
 * Firebase Cloud Functions for the "By Day" mobile app.
 * This module integrates Firestore with Algolia for real-time search indexing.
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const algoliasearch = require("algoliasearch"); // Import the Algolia client

// TODO: Replace these empty strings with your actual Algolia credentials.
const ALGOLIA_APP_ID = '';     // Your Algolia Application ID
const ALGOLIA_ADMIN_KEY = '';  // Your Algolia Admin API Key

// The name of the Algolia index to be used for services.
const ALGOLIA_INDEX_NAME = 'services';

// Initialize the Firebase Admin SDK.
admin.initializeApp();

/**
 * Firestore trigger that fires on any write operations (create, update, delete)
 * to documents in the "services" collection. This function updates the Algolia index
 * accordingly.
 */
exports.onService = functions.firestore
  .document('services/{sId}')
  .onWrite(async (change, context) => {
    const serviceId = context.params.sId;

    // Document deletion: remove the object from Algolia.
    if (!change.after.exists) {
      console.log(`Service document ${serviceId} was deleted. Removing from Algolia index.`);
      return removeFromAlgolia(serviceId);
    } else {
      // Document update or creation: update the Algolia index.
      const data = change.after.data();
      // Ensure that the objectID is set to the Firestore document ID.
      data.objectID = serviceId;
      console.log(`Updating/Adding service document ${serviceId} to Algolia index.`);
      return updateAlgolia(data);
    }
  });

/**
 * Updates or adds an object in the Algolia index with the provided data.
 *
 * @param {Object} data - The Firestore document data for the service.
 */
async function updateAlgolia(data) {
  try {
    // Initialize the Algolia client and index.
    const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
    const index = client.initIndex(ALGOLIA_INDEX_NAME);

    // Save or update the service object in the Algolia index.
    await index.saveObject(data);
    console.log(`Algolia index updated for objectID: ${data.objectID}`);
  } catch (error) {
    console.error("Error updating Algolia index:", error);
  }
}

/**
 * Removes an object from the Algolia index.
 *
 * @param {string} objectID - The Firestore document ID (objectID) to remove.
 */
async function removeFromAlgolia(objectID) {
  try {
    const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
    const index = client.initIndex(ALGOLIA_INDEX_NAME);

    // Delete the object from the Algolia index.
    await index.deleteObject(objectID);
    console.log(`Algolia index removed objectID: ${objectID}`);
  } catch (error) {
    console.error("Error removing object from Algolia index:", error);
  }
}

/**
 * Firestore trigger for "bookings" collection.
 * This is a placeholder for handling booking success events.
 * You can expand this function to send notifications, update statuses, etc.
 */
exports.onBookingSuccess = functions.firestore
  .document('bookings/{bId}')
  .onWrite(async (change, context) => {
    const bookingId = context.params.bId;
    const data = change.after.data();
    // For now, simply log the event. Extend this as needed.
    console.log(`Booking event processed for document: ${bookingId}`);
  });
