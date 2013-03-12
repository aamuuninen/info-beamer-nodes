<?php
	class forecast {
		public $weekday;
		public $temp;
		public $pressure;
		public $humidity;
		public $speed;
		public $deg;
		public $desc;
	}
	
	function toWeekday($id) {
		switch ($id) {
			case 1:
				return "Monday";
			case 2:
				return "Tuesday";
			case 3:
				return "Wednesday";
			case 4:
				return "Thursday";
			case 5:
				return "Friday";
			case 6:
				return "Saturday";
			case 7:
				return "Sunday";
			default:
				return "Unknown weekday-id: " . $id;			
		}
	}
	
	function convertTemperature($input) {
		return $input - 273.15;
	}


	$data = file_get_contents("http://api.openweathermap.org/data/2.2/forecast/city/2925177?mode=daily_compact");
	$data = json_decode($data, true);
	
	//Array ( [dt] => 1363088289 [temp] => 271 [night] => 271.02 [eve] => 276.28 [morn] => 271 [pressure] => 940.02 [humidity] => 97.4 [weather] => Array ( [0] => Array ( [id] => 601 [main] => Snow [description] => snow [icon] => 13n ) ) [speed] => 3.1 [deg] => 194 ) 
	$forecast = array();
	foreach($data["list"] as $dayforecast) {
		$t = new forecast();
		$t->weekday = toWeekday(date('N', $dayforecast["dt"]));
		$t->temp = convertTemperature($dayforecast["temp"]);
		$t->pressure = $dayforecast["pressure"];
		$t->humidity = $dayforecast["humidity"];
		$t->speed = $dayforecast["speed"];
		$t->deg = $dayforecast["deg"];
		$t->desc = $dayforecast["weather"][0]["description"];
		array_push($forecast, $t);
	}
	echo json_encode($forecast);
?>