/**************************************************
 * FEL3250 Network Optimization
 * Dijkstra's shortest path method
 *
 * Håkan Terelius <hakante@kth.se>
 * February 2, 2014
 *
 * Compile with:
 * $ g++ -Wall -O2 dijkstra.cpp -o dijkstra
 *
 * Run with:
 * $ ./dijkstra
 *
 * Output:
 * Distance from 1 to 1 is 0
 * Distance from 1 to 2 is 2
 * Distance from 1 to 3 is 6
 * Distance from 1 to 4 is 5
 * Distance from 1 to 5 is 6
 * Distance from 1 to 6 is 8
 **************************************************/
#include <vector>
#include <set>
using namespace std;

// Type for edge weights
typedef int EdgeWeight;
const EdgeWeight infinity = 1<<28;
// Adjacency list for network.
// Each link represented by destination node and a edge weight
typedef vector<vector<pair<int,EdgeWeight> > > WeightedGraph;

// Compute the shortest path in a network with only non-negative edge weights using Dijkstra's algorithm
// Complexity: O(n log n + m)
vector<EdgeWeight> dijkstra(const WeightedGraph &g, const int startNode) {
	vector<EdgeWeight> distance(g.size(), infinity); // Label each node at infinite distance
	set<pair<EdgeWeight,int> > queue; // A minimum label queue for candidates
	distance[startNode] = 0;
	queue.insert(make_pair(distance[startNode], startNode));
	while(!queue.empty()) {
		// Pick the minimum labeled element from the candidate list.
		const int node = queue.begin()->second;
		queue.erase(queue.begin());
		for(typeof(g[node].begin()) it = g[node].begin(); it != g[node].end(); ++it) {
			// Check each neighbor's label
			const EdgeWeight d = distance[node] + it->second;
			if (distance[it->first] > d) {
				queue.erase(make_pair(distance[it->first], it->first)); // Remove previous version from the candidate list if it exists
				distance[it->first] = d; // Update label
				queue.insert(make_pair(distance[it->first], it->first)); // Add to candidate list
			}
		}
	}
	return distance;
}

// Adds a weighed edge to the graph, correcting the 1-based index.
inline void addEdge(WeightedGraph &g, const int startNode, const int endNode, const EdgeWeight weight) {
	g[startNode-1].push_back(make_pair(endNode-1, weight));
}

int main(int argc, char const *argv[]) {
	// Create the network with 6 nodes.
	WeightedGraph g(6);
	addEdge(g, 1, 2, 2); addEdge(g, 1, 3, 8);
	addEdge(g, 2, 3, 5); addEdge(g, 2, 4, 3);
	addEdge(g, 3, 2, 6); addEdge(g, 3, 5, 0);
	addEdge(g, 4, 3, 1); addEdge(g, 4, 5, 7); addEdge(g, 4, 6, 6);
	addEdge(g, 5, 4, 4); addEdge(g, 5, 6, 2);
	// Compute the shortest paths from node 1 to all other nodes
	const int startNode = 1;
	vector<EdgeWeight> distance = dijkstra(g, startNode-1);
	// Print the distances
	for (size_t i = 0; i < distance.size(); ++i)
		printf("Distance from %d to %ld is %d\n",startNode,i+1,distance[i]);
	return 0;
}