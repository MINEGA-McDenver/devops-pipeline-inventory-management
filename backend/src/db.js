const sqlite3 = require("sqlite3").verbose();
const db = new sqlite3.Database("./inventory.db");

// Initialize database schema
function initializeDatabase() {
  return new Promise((resolve, reject) => {
    db.serialize(() => {
      // Create table if it doesn't exist
      db.run(`CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        quantity INTEGER
      )`, (err) => {
        if (err) {
          reject(err);
          return;
        }
        
        // Check if cost column exists
        db.all("PRAGMA table_info(items)", [], (err, columns) => {
          if (err) {
            reject(err);
            return;
          }
          
          const hasCostColumn = columns.some(col => col.name === 'cost');
          if (!hasCostColumn) {
            // Add cost column if it doesn't exist
            db.run("ALTER TABLE items ADD COLUMN cost REAL DEFAULT 0", (err) => {
              if (err) reject(err);
              else resolve();
            });
          } else {
            resolve();
          }
        });
      });
    });
  });
}

// Initialize on module load
initializeDatabase().catch(err => console.error("Database initialization error:", err));

module.exports = db;
