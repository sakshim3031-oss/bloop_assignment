# NOTES

## Task 1 — Approach & Decisions

For Task 1, my goal was to build a clean and scalable structure for handling collections data.

### Data Modeling
I created a `Collection` model with all required fields such as id, title, description, and metadata.  
I used JSON serialization (`toJson` and `fromJson`) to easily convert between objects and storage format.

### Caching Strategy
I used "Hive" for local caching because it is lightweight and fast.  
The approach I followed:
- First load data from cache to show UI quickly
- Then fetch fresh data in the background
- Update UI once fresh data is available

This ensures a better user experience with fast loading and updated content.

### State Management
I used 'Riverpod (AsyncNotifier)' because:
- It provides clear separation of logic and UI
- It handles async states (loading, error, data) cleanly
- It is scalable for larger applications

---

## Task 2 — Debugging Approach

While reviewing the given code, I focused on understanding the real impact of each bug rather than just fixing syntax.

### Bug 1 — Hive Initialization
The wrong directory was used for storing cache data.  
I fixed it by using `getApplicationSupportDirectory()` to ensure proper storage.

### Bug 2 — Null Handling
The code assumed cached data always exists.  
This could cause a crash when data is null.  
I added a null check to safely handle this case.

### Bug 3 — Performance Issue
The original code recreated a Future inside the UI on every rebuild.  
This leads to repeated executions and poor performance.  
I avoided this pattern and used a more efficient approach for image loading.

### Bug 4 — Firestore Data Mutation
The original code modified Firestore data directly.  
This can cause unexpected side effects.  
The correct approach is to create a copy of the data before modifying it.

---

## Final Thoughts

I focused on writing clean, maintainable code and ensuring:
- No runtime crashes
- Good performance
- Clear separation of concerns

I also made sure that each fix addressed the actual problem and not just the surface-level issue.