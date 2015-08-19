var mascotimg = "./mascots/default.png"; // mascot image
var mascotwidth = 270; // width of the mascot
var mascotheight = 380; // height of the mascot
var mascotopacity = 0.7; // transparency of the mascot
var mascotpos = "right"; // left or right
var usequotes = true; // set to false to disable quotes
var usemascots = true; // set to false to disable mascots
var textcolor = "#538bab"; // color to use for cells

// ADD NEW CELLS AND PAGES BELOW. IT MAY TAKE YOU A MOMENT TO WORK OUT THE FORMAT, BUT IT'S A GOOD METHOD.
// Oh, and keep the names less than 5 characters. It's "the style".

var Pages = [
	new Page([ 
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/"),
		new Cell("Exam", "http://example.com/")]),
	new Page([
		new Cell("Exam", "http://example.com/")]),
	new Page([]),
	new Page([]),
	new Page([])
];

// ADD IN QUOTES TO BE DISPLAYED ON THE HOMEPAGE BELOW
// You can use tags like <b> and <i>

var Quotes = [
	new Quote("Example Author", "Example Quote"),
	new Quote("Example Author", "Example Quote")
]
