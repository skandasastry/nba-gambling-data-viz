// JavaScript source code
function initViz() {
    var containerDiv = document.getElementById("tableauViz"),
    url = "https://public.tableau.com/views/nba-bettingproject-bars-spread/EastWestComps?:display_count=y&publish=yes&:origin=viz_share_link";
    var options = {
     device: "desktop"
	}

    var viz = new tableau.Viz(containerDiv, url,options);
}