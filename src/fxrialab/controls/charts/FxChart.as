package fxrialab.controls.charts
{
	import flash.display.DisplayObject;
	
	import mx.charts.PieChart;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.managers.ILayoutManagerClient;
	import mx.messaging.AbstractConsumer;
	
	[Style(name="coordinateClass", inherit="no", type="Class")]
	
	public class FxChart extends UIComponent
	{
		public static const HORIZONTAL_BAR:String = 'horizontalBar';
		public static const VERTICAL_BAR:String = 'verticalBar';
		public static const LINE:String = 'line';
		public static const PIE:String = 'pie';
		public static const DOUGHNUT:String = 'doughnut';
		
		private var _showCoordinate:Boolean = false;
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		private var coordinateAxis:DisplayObject;
		private var charts:IList = new ArrayList();
		private var _typeField:String = "type";
		private var _valueField:String = "value";
		private var _dataSeriesField:String = "data";
		private var _labelField:String = "label";
		private var _fillField:String = "fill";
		private var _strokeField:String = "stroke";
		private var _gap:Number = 10;
		private var _offSet:Number = 10;
		private var _title:String;
		private var char:Array = [];
		private var chart:DisplayObject;
		
		public function FxChart()
		{
			super();
			setStyle('coordinateClass', CoordinateAxis);
		}

		public function get dataProvider():IList
		{
			return _dataProvider;
		}

		public function set dataProvider(value:IList):void
		{
			if(value == _dataProvider) return;
			
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
			
			for(var i:int=0; i < dataProvider.length; i++){
				var type:String = (dataProvider.getItemAt(i) as Object)[typeField];
				var stroke:String = (dataProvider.getItemAt(i) as Object)[strokeField];
				var data:Object = (dataProvider.getItemAt(i) as Object)[_dataSeriesField];
				charts.addItem( { type: type, stroke: stroke, data: data } );
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			for(var i:int=0; i < charts.length; i++){
				var chartDataItem:Object = charts.getItemAt(i);
				var chartType:String = String(chartDataItem[typeField]);
				var dataItems:IList = new ArrayList(chartDataItem[_dataSeriesField] as Array);
				
				var chartFirstDataItem:Object = charts.getItemAt(0);
				var chartFirstType:String = String(chartFirstDataItem[typeField]);
				var firstDataItems:IList = new ArrayList(chartFirstDataItem[_dataSeriesField] as Array);
				
				var maxSum:int = 0;
				for (var j:int = 0; j < firstDataItems.length; j++) {
					var getValue:Object = firstDataItems.getItemAt(j);
					maxSum += getValue[valueField];
				}
				//trace("Max:", maxSum);
				var calcSum:int = 0;
				for (j = 0; j < dataItems.length; j++) {
					var data1:Object = dataItems.getItemAt(j);
					calcSum += data1[valueField];
					if (calcSum > maxSum) {
						maxSum = calcSum;
					}
				}
				//trace("calculateSum:", calcSum);
				
				
				//trace("finally Max:", maxSum);

				//draw axis 
				if(i == 0){
					if(chartFirstType == HORIZONTAL_BAR || chartFirstType == VERTICAL_BAR || chartFirstType == LINE){
						//draw axis ?
						showCoordinate = true;
						if(showCoordinate){
							var orientation:String = "horizontal";
							if(chartFirstType == HORIZONTAL_BAR){
								//draw hor axis
								orientation = "horizontal";
							}
							else if(chartFirstType == VERTICAL_BAR){
								//draw ver axis
								orientation = "vertical";
							}
							else if(chartFirstType == LINE){
								//check for next chart type
								if(chartType == HORIZONTAL_BAR){
									orientation == "horizontal";
								}else if(chartType == VERTICAL_BAR){
									orientation == "vertical";
								}
							}
							
							if(!coordinateAxis){
								var clazz:Class = getStyle('coordinateClass') as Class;
								coordinateAxis = new clazz() as DisplayObject;
								if(dataProvider){
									coordinateAxis["dataProvider"] = dataItems;
									
									//trace("max Sum111:", maxSum);
								}
								coordinateAxis["title"] = title;
								
								addChild(coordinateAxis);
								coordinateAxis['orientation'] = orientation;
							}
							
						}
					}
				}
				
				
				//draw charts
				var chart:DisplayObject = generateChart(chartDataItem);
				if(chart is LineChart){
					(chart as LineChart).direction = orientation;
				}
				if(i==0)
					addChild(chart);
				else{
					if(chartFirstType == HORIZONTAL_BAR || chartFirstType == LINE){
						if(chartType == HORIZONTAL_BAR || chartType == LINE){
							addChild(chart);		
						}	
					}else if(chartFirstType == VERTICAL_BAR || chartFirstType == LINE){
						if(chartType == VERTICAL_BAR || chartType == LINE){
							addChild(chart);		
						}
						
					}else if(chartFirstType == PIE && chartType == PIE){
						addChild(chart);	
					}					
				}
				
			}
			
		}
		
		protected function max(data:IList):Number {
			
			var maxSum:int = 0;
			var calcSum:int = 0;
			for(var i:int=0; i < data.length; i++){
				var getData:Object = data.getItemAt(i);
				var dataItems:IList = new ArrayList(getData[_dataSeriesField] as Array);
				
				var getFirstData:Object = data.getItemAt(0);
				var firstDataItems:IList = new ArrayList(getFirstData[_dataSeriesField] as Array);
			
				
				for(var j:int=0; j < firstDataItems.length; j++){
					var max:Object = firstDataItems.getItemAt(j);
					maxSum += max[valueField];
				}
				
				for(j=0; j < dataItems.length; j++){
					var calc:Object = dataItems.getItemAt(j);
					calcSum += calc[valueField];
					//trace(calcSum);
				}
				
				if(calcSum > maxSum){
					maxSum = calcSum;
				}
				
			}
			
			return maxSum;
		}
		
		protected function generateChart(data:Object):DisplayObject{
			var chartType:String = String(data[typeField]);
			var dataItems:IList = new ArrayList(data[_dataSeriesField] as Array);
			
			switch(chartType){
				case VERTICAL_BAR:
					chart = new VBarChart();
					(chart as VBarChart).dataProvider = dataItems;
					(chart as VBarChart).gap = gap;
					(chart as VBarChart).offSet = offSet;
					break;
				case HORIZONTAL_BAR:
					chart = new HBarChart();
					(chart as HBarChart).dataProvider = dataItems;
					(chart as HBarChart).gap = gap;
					(chart as HBarChart).offSet = offSet;
					break;
				case PIE:
					chart = new PieCharts();
					(chart as PieCharts).dataProvider = dataItems;
					break;
				case LINE:
					var getLineStroke:String = String(data[strokeField]);
					var lineStroke:uint = (getLineStroke.search('#')==0) ? uint(getLineStroke.replace('#', '0x')) : uint(getLineStroke);
					
					chart = new LineChart();	
					(chart as LineChart).dataProvider = dataItems;
					(chart as LineChart).gap = gap;
					(chart as LineChart).offSet = offSet;
					(chart as LineChart).stroke = (lineStroke) ? lineStroke : 0x3f9b90;
					break;
				case DOUGHNUT:
					chart = new DoughnutCharts();
					(chart as DoughnutCharts).dataProvider = dataItems;
					break;
			}
			chart['labelField'] = labelField;
			chart['valueField'] = valueField;
			
			char.push(chart);
			
			return chart;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w,h);
			if(coordinateAxis){
				coordinateAxis.visible = showCoordinate;
				coordinateAxis.width = w;
				coordinateAxis.height = h;
			}
			for(var i:int = 0; i< char.length;i++){
				chart = char[i] as DisplayObject;
				chart.width = w;
				chart.height= h;
			}
		}
		
		public function get showCoordinate():Boolean
		{
			return _showCoordinate;
		}

		public function set showCoordinate(value:Boolean):void
		{
			_showCoordinate = value;
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get valueField():String
		{
			return _valueField;
		}

		public function set valueField(value:String):void
		{
			_valueField = value;
		}

		public function get typeField():String
		{
			return _typeField;
		}

		public function set typeField(value:String):void
		{
			_typeField = value;
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
		}

		public function get offSet():Number
		{
			return _offSet;
		}

		public function set offSet(value:Number):void
		{
			_offSet = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get fillField():String
		{
			return _fillField;
		}

		public function set fillField(value:String):void
		{
			_fillField = value;
		}

		public function get strokeField():String
		{
			return _strokeField;
		}

		public function set strokeField(value:String):void
		{
			_strokeField = value;
			redrawSkin = true;
			invalidateProperties();
		}

		
	}
}