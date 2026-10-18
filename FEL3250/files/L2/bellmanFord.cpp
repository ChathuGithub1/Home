/**************************************************
 * FEL3250 Network Optimization
 * Bellman-Ford's shortest path method
 *
 * Håkan Terelius <hakante@kth.se>
 * February 2, 2014
 *
 * Compile with:
 * $ g++ -Wall -O2 bellmanFord.cpp -o bellmanFord
 *
 * Run with:
 * $ ./bellmanFord
 *
 * Output:
 * Distance from 1 to 1 is 0
 * Distance from 1 to 2 is 3
 * Distance from 1 to 3 is 7
 * Distance from 1 to 4 is 5
 * Distance from 1 to 5 is 4
 * Distance from 1 to 6 is -1
 * Distance from 1 to 7 is 5
 **************************************************/
#include <vector>
#include <stdexcept>
using namespace std;

// Type for edge weights
typedef int EdgeWeight;
const EdgeWeight infinity = 1<<28;
// Adjacency list for network.
// Each link represented by destination node and a edge weight
typedef vector<vector<pair<int,EdgeWeight> > > WeightedGraph;

// Compute the shortest path in a network using Bellman-Ford's algorithm
// Throws a runtime_error if the network contains a negative cycle
// Complexity: O(nm)
vector<EdgeWeight> bellmanFord(const WeightedGraph &g, const int startNode) {
	vector<EdgeWeight> distance(g.size(), infinity); // Label each node at infinite distance
	distance[startNode] = 0;
	for(size_t step = 0; step < g.size(); ++step) // Do n steps
		for(size_t i = 0; i < g.size(); ++i)
			for(typeof(g[i].begin()) it = g[i].begin(); it != g[i].end(); ++it)
				distance[it->first] = min(distance[it->first], distance[i]+it->second);
	// Check if the algorithm has converged, otherwise there exists a negative cycle
	for(size_t i = 0; i < g.size(); ++i)
		for(typeof(g[i].begin()) it = g[i].begin(); it != g[i].end(); ++it)
			if(distance[it->first]>distance[i]+it->second)
				throw runtime_error("Negative cycle exists");
	return distance;
}

// Adds a weighed edge to the graph, correcting the 1-based index.
inline void addEdge(WeightedGraph &g, const int startNode, const int endNode, const EdgeWeight weight) {
	g[startNode-1].push_back(make_pair(endNode-1, weight));
}

int main(int argc, char const *argv[]) {
	// Create the network with 7 nodes.
	WeightedGraph g(7);
	addEdge(g, 1, 2, 3); addEdge(g, 1, 3,10);
	addEdge(g, 2, 3, 4); addEdge(g, 2, 4, 7); addEdge(g, 2, 5, 1);
	addEdge(g, 3, 4,-2); addEdge(g, 3, 6, 7);
	addEdge(g, 4, 5, 2); addEdge(g, 4, 6,-6);
	addEdge(g, 5, 7,15);
	addEdge(g, 6, 5, 9); addEdge(g, 6, 7, 6);
	// Add this edge to create a negative cycle: addEdge(g, 6, 3, 2);

	// Compute the shortest paths from node 1 to all other nodes
	const int startNode = 1;
	vector<EdgeWeight> distance = bellmanFord(g, startNode-1);
	// Print the distances
	for (size_t i = 0; i < distance.size(); ++i)
		printf("Distance from %d to %ld is %d\n",startNode,i+1,distance[i]);
	return 0;
}