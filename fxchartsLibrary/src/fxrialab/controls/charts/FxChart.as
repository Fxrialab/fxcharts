package fxrialab.controls.charts
{
	import flash.display.DisplayObject;
	
	import mx.charts.PieChart;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.UIComponent;
	import mx.managers.ILayoutManagerClient;
	import mx.messaging.AbstractConsumer;
	
	[Style(name="coordinateClass",inherit="no",type="Class")]
	
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
		private var _marginTop:Number = 30;
		private var _marginRight:Number = 10;
		private var _marginBottom:Number = 10;
		private var _marginLeft:Number = 10;
		private var getMax:Array = [];
		
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
		
		public var positiveValueArrays:Array = [];
		public var negativeValueArrays:Array = [];
		public var listLengthOfLine:Array = [];
		
		public function set dataProvider(value:IList):void
		{
			if (value == _dataProvider)
				return;
			
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
			
			for (var i:int = 0; i < dataProvider.length; i++)
			{
				var type:String = (dataProvider.getItemAt(i) as Object)[typeField];
				var stroke:String = (dataProvider.getItemAt(i) as Object)[strokeField];
				var data:Object = (dataProvider.getItemAt(i) as Object)[_dataSeriesField];
				charts.addItem( { type: type, stroke: stroke, data: data } );
				//get min, max for arrays
				var dataItemsChart:Object = dataProvider.getItemAt(i);
				var itemsData:IList = new ArrayList(dataItemsChart[_dataSeriesField] as Array);
				//get chart first type
				var chartFirstDataItem:Object = dataProvider.getItemAt(0);

				//get length of each type for group charts
				var getChartsFirstType:String = String(chartFirstDataItem[typeField]);
				if(getChartsFirstType == LINE || getChartsFirstType == HORIZONTAL_BAR || getChartsFirstType == VERTICAL_BAR){
					listLengthOfLine.push(itemsData.length);
				}
				for (var k:int = 0; k < itemsData.length; k++) {
					var getDataValue:Object = itemsData.getItemAt(k);
					//calc += getDataValue[valueField];
					
					if(getDataValue[valueField] >= 0 && listLengthOfLine[0] == itemsData.length) {
						positiveValueArrays.push(getDataValue[valueField]);
					}
					
					if(getDataValue[valueField] < 0 && listLengthOfLine[0] == itemsData.length){
						negativeValueArrays.push(getDataValue[valueField]);
					}
				}
				//positiveValueArray.push(calc);
				
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			for (var i:int = 0; i < charts.length; i++)
			{
				var chartDataItem:Object = charts.getItemAt(i);
				var chartType:String = String(chartDataItem[typeField]);
				var dataItems:IList = new ArrayList(chartDataItem[_dataSeriesField] as Array);
				
				var chartFirstDataItem:Object = charts.getItemAt(0);
				var chartFirstType:String = String(chartFirstDataItem[typeField]);
				var firstDataItems:IList = new ArrayList(chartFirstDataItem[_dataSeriesField] as Array);
				
				//set number point for line
				var lineChartDefault:Number = listLengthOfLine[0];
				//draw axis 
				if (i == 0)
				{
					if (chartFirstType == HORIZONTAL_BAR || chartFirstType == VERTICAL_BAR || chartFirstType == LINE)
					{
						//draw axis ?
						showCoordinate = true;
						if (showCoordinate)
						{
							var orientation:String = "horizontal";
							if (chartFirstType == HORIZONTAL_BAR)
							{
								//draw hor axis
								orientation = "horizontal";
							}
							else if (chartFirstType == VERTICAL_BAR)
							{
								//draw ver axis
								orientation = "vertical";
							}
							else if (chartFirstType == LINE)
							{
								//check for next chart type
								if (chartType == HORIZONTAL_BAR)
								{
									orientation == "horizontal";
								}
								else if (chartType == VERTICAL_BAR)
								{
									orientation == "vertical";
								}
							}
							
							if (!coordinateAxis)
							{
								var clazz:Class = getStyle('coordinateClass') as Class;
								coordinateAxis = new clazz() as DisplayObject;
								if (dataProvider)
								{
									coordinateAxis["dataProvider"] = dataItems;
								}
								if (positiveValueArrays && positiveValueArrays.length > 0){
									coordinateAxis["maxValue"] = findMax(positiveValueArrays);
								}
								if (negativeValueArrays && negativeValueArrays.length > 0){
									coordinateAxis["minValue"] = findMin(negativeValueArrays);
								}
								coordinateAxis["title"] = title;
								coordinateAxis['marginTop'] = marginTop;
								coordinateAxis['marginRight'] = marginRight;
								coordinateAxis['marginBottom'] = marginBottom;
								coordinateAxis['marginLeft'] = marginLeft;
								
								addChild(coordinateAxis);
								coordinateAxis['orientation'] = orientation;
							}
							
						}
					}
				}
				//trace(lineChartDefault);
				//draw charts
				var chart:DisplayObject = generateChart(chartDataItem);
				if (chart is LineChart)
				{
					(chart as LineChart).direction = orientation;
				}
				if (i == 0)
					addChild(chart);
				else
				{
					if (chartFirstType == HORIZONTAL_BAR || chartFirstType == LINE)
					{
						if (chartType == HORIZONTAL_BAR || chartType == LINE)
						{
							if(chartType == LINE){
								if(dataItems.length == lineChartDefault){
									addChild(chart);
								}
							}else if(chartType == HORIZONTAL_BAR){
								addChild(chart);
							}
						}
					}
					else if (chartFirstType == VERTICAL_BAR || chartFirstType == LINE)
					{
						if (chartType == VERTICAL_BAR || chartType == LINE)
						{
							if(chartType == LINE){
								if(dataItems.length == lineChartDefault){
									addChild(chart);
								}
							}else if(chartType == VERTICAL_BAR){
								addChild(chart);
							}
						}
						
					}
					else if (chartFirstType == PIE && chartType == PIE)
					{
						addChild(chart);
					}
				}
				
			}
		
		}
		
		protected function findMax(arrays:Array):Number
		{			
			var max:Number;
			max = arrays[0];
			for (var i:int = 0; i < arrays.length; i ++) {
				if (arrays[i] > max) {
					max = arrays[i];
				}
			}
			return max;
		}
		
		protected function findMin(arrays:Array):Number
		{
			var min:Number;
			min = arrays[0];
			for (var i:int = 0; i < arrays.length; i++){
				if(arrays[i] < min){
					min = arrays[i];
				}
			}
			return min;
		}
		
		protected function generateChart(data:Object):DisplayObject
		{
			var chartType:String = String(data[typeField]);
			var dataItems:IList = new ArrayList(data[_dataSeriesField] as Array);
			
			switch (chartType)
			{
				case VERTICAL_BAR: 
					chart = new VBarChart();
					(chart as VBarChart).dataProvider = dataItems;
					(chart as VBarChart).gap = gap;
					(chart as VBarChart).offSet = offSet;
					(chart as VBarChart).marginTop = marginTop;
					(chart as VBarChart).marginRight = marginRight;
					(chart as VBarChart).marginBottom = marginBottom;
					(chart as VBarChart).marginLeft = marginLeft;
					break;
				case HORIZONTAL_BAR: 
					chart = new HBarChart();
					(chart as HBarChart).dataProvider = dataItems;
					(chart as HBarChart).gap = gap;
					(chart as HBarChart).offSet = offSet;
					(chart as HBarChart).marginTop = marginTop;
					(chart as HBarChart).marginRight = marginRight;
					(chart as HBarChart).marginBottom = marginBottom;
					(chart as HBarChart).marginLeft = marginLeft;
					//call max value & min value 
					if (positiveValueArrays && positiveValueArrays.length > 0){
						(chart as HBarChart).maxValue = findMax(positiveValueArrays);
					}
					if (negativeValueArrays && negativeValueArrays.length > 0){
						(chart as HBarChart).minValue = findMin(negativeValueArrays);
					}
					break;
				case LINE: 
					var getLineStroke:String = String(data[strokeField]);
					var lineStroke:uint = (getLineStroke.search('#') == 0) ? uint(getLineStroke.replace('#', '0x')) : uint(getLineStroke);
					
					chart = new LineChart();
					(chart as LineChart).dataProvider = dataItems;
					(chart as LineChart).gap = gap;
					(chart as LineChart).offSet = offSet;
					(chart as LineChart).marginTop = marginTop;
					(chart as LineChart).marginRight = marginRight;
					(chart as LineChart).marginBottom = marginBottom;
					(chart as LineChart).marginLeft = marginLeft;
					(chart as LineChart).stroke = (lineStroke) ? lineStroke : 0x3f9b90;
					break;
				case PIE: 
					chart = new PieCharts();
					(chart as PieCharts).dataProvider = dataItems;
					(chart as PieCharts).marginTop = marginTop;
					(chart as PieCharts).marginRight = marginRight;
					(chart as PieCharts).marginBottom = marginBottom;
					(chart as PieCharts).marginLeft = marginLeft;
					break;
				case DOUGHNUT: 
					chart = new DoughnutCharts();
					(chart as DoughnutCharts).dataProvider = dataItems;
					(chart as DoughnutCharts).marginTop = marginTop;
					(chart as DoughnutCharts).marginRight = marginRight;
					(chart as DoughnutCharts).marginBottom = marginBottom;
					(chart as DoughnutCharts).marginLeft = marginLeft;
					break;
			}
			chart['labelField'] = labelField;
			chart['valueField'] = valueField;
			
			char.push(chart);
			
			return chart;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if (coordinateAxis)
			{
				coordinateAxis.visible = showCoordinate;
				coordinateAxis.width = w;
				coordinateAxis.height = h;
				
			}
			for (var i:int = 0; i < char.length; i++)
			{
				chart = char[i] as DisplayObject;
				chart.width = w;
				chart.height = h;
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
		
		public function get marginTop():Number 
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void 
		{
			_marginTop = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void 
		{
			_marginRight = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void 
		{
			_marginBottom = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void 
		{
			_marginLeft = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
	}
}