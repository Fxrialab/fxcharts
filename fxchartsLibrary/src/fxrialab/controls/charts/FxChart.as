package fxrialab.controls.charts
{
	import flash.display.DisplayObject;
	
	import fxrialab.utils.ArrayUtilities;
	
	import mx.charts.PieChart;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.UIComponent;
	import mx.managers.ILayoutManagerClient;
	import mx.messaging.AbstractConsumer;
	
	[Style(name="coordinateClass",inherit="no",type="Class")]
	
	[Style(name="fontDefault", inherit="yes", type="String")]
	[Style(name="sizeDefault", inherit="yes", type="Number")]
	[Style(name="alignDefault", inherit="yes", type="String")]
	[Style(name="leftAlign", inherit="yes", type="String")]
	[Style(name="rightAlign", inherit="yes", type="String")]
	[Style(name="titleSize", inherit="yes", type="Number")]
	[Style(name="titleFont", inherit="yes", type="String")]
	public class FxChart extends UIComponent
	{
		public static const HORIZONTAL_BAR:String = 'horizontalBar';
		public static const VERTICAL_BAR:String = 'verticalBar';
		public static const LINE:String = 'line';
		public static const PIE:String = 'pie';
		public static const DOUGHNUT:String = 'doughnut';
		public static const CLUSTERED:String = 'clustered';
		public static const STACKED:String = 'stacked';
		
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
		private var _gap:Number = 20;
		private var _offSet:Number = 10;
		private var _titleField:String = "title";
		private var _config:Array;
		private var _marginTop:Number = 30;
		private var _marginRight:Number = 10;
		private var _marginBottom:Number = 10;
		private var _marginLeft:Number = 10;

		private var _numberLineLandMarkDefault:Number = 10;
		private var _numberLineLandMarkForNegativeAxis:Number;
		
		private var char:Array = [];
		private var chart:DisplayObject;
		private var maxValue:Number;
		private var minValue:Number;
		private var barWidth:Number;
		private var barHeight:Number;
		
		private var barShift:Number = 0;
		
		public function FxChart()
		{
			super();
			setStyle('coordinateClass', CoordinateAxis);
			
			this.setStyle('fontDefault','Arial');
			this.setStyle('sizeDefault',6);
			this.setStyle('alignDefault', 'center');
			
			this.setStyle('leftAlign', 'left');
			this.setStyle('rightAlign', 'right');
			
			this.setStyle('titleSize',10);
			this.setStyle('titleFont','Time New Normal');
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		private var positiveValueArrays:Array = [];
		private var negativeValueArrays:Array = [];
		public var listLengthOfLine:Array = [];
		private var seriesChartNumber:Array = [];
		private var valueOfSeriesBar:Array = [];
		private var labelOfSeriesBar:Array = [];
		private var sumValueStackedBar:Array = [];
		private var fillOfStackedBar:Array = [];
		private var titleOfStackedBar:Array = [];
		
		private var dataProviderOfStackedBar:IList = new ArrayList();
		public var typeOfBar:String;
		
		public function set dataProvider(value:IList):void
		{
			if (value == _dataProvider)
				return;
			
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
			invalidateDisplayList();
			
			for (var i:int = 0; i < dataProvider.length; i++)
			{
				var type:String = (dataProvider.getItemAt(i) as Object)[typeField];
				//var fill:String = (dataProvider.getItemAt(i) as Object)[fillField];
				var getFill:String = ((dataProvider.getItemAt(i) as Object)[fillField] == null) ? "0xDC2400" : (dataProvider.getItemAt(i) as Object)[fillField];
				var fill:uint = (getFill.search('#') == 0) ? uint(getFill.replace('#', '0x')) : uint(getFill);
				var stroke:String = (dataProvider.getItemAt(i) as Object)[strokeField];
				var title:String = (dataProvider.getItemAt(i) as Object)[labelField];
				var data:Object = (dataProvider.getItemAt(i) as Object)[_dataSeriesField];
				charts.addItem( { type: type, fill: fill, stroke: stroke, data: data } );
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
					var getDataSeries:Object = itemsData.getItemAt(k);
					//calc += getDataValue[valueField];
					
					if(getDataSeries[valueField] >= 0 && listLengthOfLine[0] == itemsData.length)
						positiveValueArrays.push(getDataSeries[valueField]);
					
					if(getDataSeries[valueField] < 0 && listLengthOfLine[0] == itemsData.length)
						negativeValueArrays.push(getDataSeries[valueField]);
					
					if(type == HORIZONTAL_BAR || type == VERTICAL_BAR && listLengthOfLine[0] == itemsData.length) {
						labelOfSeriesBar.push(getDataSeries[labelField]);
						valueOfSeriesBar.push(getDataSeries[valueField]);
						fillOfStackedBar.push(fill);
						titleOfStackedBar.push(title);
					}
				}
				//positiveValueArray.push(calc);
				if(type == HORIZONTAL_BAR && listLengthOfLine[0] == itemsData.length) {
					seriesChartNumber.push(HORIZONTAL_BAR);
				}else if(type == VERTICAL_BAR && listLengthOfLine[0] == itemsData.length) {
					seriesChartNumber.push(VERTICAL_BAR);
				}
			}

		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (redrawSkin == true)
			{
				redrawSkin = false;
				if(config.length == 1) {
					typeOfBar = String(config[0][typeField]);
					if(typeOfBar == null || (typeOfBar != CLUSTERED && typeOfBar != STACKED))
						typeOfBar = CLUSTERED;
					
					trace('typebar', typeOfBar);
				}
				
				if (typeOfBar == STACKED) {
					var numberSeries:Number = seriesChartNumber.length;
					var keyArrays:Array = ArrayUtilities.checkLabelOfSeries(labelOfSeriesBar, numberSeries, listLengthOfLine[0]);
					ArrayUtilities.groupValue(keyArrays.sort(Array.NUMERIC));
					ArrayUtilities.findDifficultValue(labelOfSeriesBar, keyArrays);
					ArrayUtilities.findDifficultValue(valueOfSeriesBar, keyArrays);
					ArrayUtilities.findDifficultValue(fillOfStackedBar, keyArrays);
					ArrayUtilities.findDifficultValue(titleOfStackedBar, keyArrays);
					
					sumValueStackedBar = ArrayUtilities.sumSameKeyArray(valueOfSeriesBar, valueOfSeriesBar.length/listLengthOfLine[0]);
					
					var dataSeriesOfStackedBar:Array;
					var obj:Object;
					for (i = 0; i < labelOfSeriesBar.length; i++) {
						if (i % listLengthOfLine[0] == 0){
							dataSeriesOfStackedBar = new Array();
							dataProviderOfStackedBar.addItem(dataSeriesOfStackedBar);
						}
						obj = new Object;
						obj['label'] = labelOfSeriesBar[i];
						obj['value'] = valueOfSeriesBar[i];
						obj['fill'] = fillOfStackedBar[i];
						obj['sum'] = sumValueStackedBar[i];
						
						dataSeriesOfStackedBar.push(obj);
					}
				}
				
				for (var i:int = 0; i < charts.length; i++)
				{
					var chartDataItem:Object = charts.getItemAt(i);
					var chartType:String = String(chartDataItem[typeField]);
					var dataItems:IList = new ArrayList(chartDataItem[_dataSeriesField] as Array);
					//trace(dataItems);
					var chartFirstDataItem:Object = charts.getItemAt(0);
					var chartFirstType:String = String(chartFirstDataItem[typeField]);
					var firstDataItems:IList = new ArrayList(chartFirstDataItem[_dataSeriesField] as Array);
					//trace('num chart', chartType.length);
					//set number point for line
					var lineChartDefault:Number = listLengthOfLine[0];
					//get min vs max value
					if (positiveValueArrays && positiveValueArrays.length > 0) {
						var getMaxValue:Number = (typeOfBar == STACKED) ? findMax(sumValueStackedBar) : findMax(positiveValueArrays);
						maxValue = getMaxValue + 30;
					}
					if (negativeValueArrays && negativeValueArrays.length > 0) {
						var getMinValue:Number = findMin(negativeValueArrays);
						var getNumberLandMark:Number = -getMinValue/(maxValue/numberLineLandMarkDefault);
						numberLineLandMarkForNegativeAxis = int(getNumberLandMark) + 2;
						minValue = (maxValue/numberLineLandMarkDefault) * numberLineLandMarkForNegativeAxis;
					}
					
					//trace(ArrayUtilities.groupValue(titleOfStackedBar));
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
									
									coordinateAxis['numberLineLandMarkDefault'] = numberLineLandMarkDefault;
									if (positiveValueArrays && positiveValueArrays.length > 0){
										coordinateAxis["maxValue"] = maxValue;
									}
									if (negativeValueArrays && negativeValueArrays.length > 0){
										coordinateAxis["minValue"] = minValue;
										coordinateAxis['numberLineLandMarkForNegativeAxis'] = numberLineLandMarkForNegativeAxis;
									}
									
									if(config.length == 1){
										var title:String = config[0][titleField];
										var titleDefault:String = 'Please add title to config of chart';
										coordinateAxis["title"] = (title || title !='') ? title : titleDefault;
									}								
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
					
					//trace(width);
					barWidth = ((width - (marginRight + marginLeft)) - (offSet *2 + gap * (lineChartDefault - 1)))/(lineChartDefault);
					barHeight = ((height - (marginBottom + marginTop)) - (offSet * 2 + gap * (lineChartDefault - 1))) / lineChartDefault;
					//trace('barWidth1',barWidth);
					//draw charts
					var chart:DisplayObject = generateChart(chartDataItem);
					//var barshift:Number = 0;
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
									if(dataItems.length == lineChartDefault) {
										
										if(typeOfBar && typeOfBar == CLUSTERED){
											barShift += barWidth/seriesChartNumber.length;
											chart.x = barShift;	
										}
										addChild(chart);
									}		
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
									if(dataItems.length == lineChartDefault) {
										if (typeOfBar && typeOfBar == CLUSTERED) {
											barShift += barHeight/seriesChartNumber.length;
											chart.y = -barShift;
										}
										trace('chart.y', chart.y);
										addChild(chart);
									}
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
			//var getFill:String = (data[fillField] == null) ? "0xDC2400" : data[fillField];
			var fill:uint = uint(data[fillField]);
			var dataItems:IList = new ArrayList(data[_dataSeriesField] as Array);
			trace("number series:", seriesChartNumber.length);
			var dd:IList = new ArrayList(data['dataStacked'] as Array);
			switch (chartType)
			{
				case VERTICAL_BAR: 
					chart = new VBarChart();
					(chart as VBarChart).dataProvider = (typeOfBar == STACKED) ? dataProviderOfStackedBar : dataItems;
					(chart as VBarChart).fill = fill;
					(chart as VBarChart).gap = gap;
					(chart as VBarChart).offSet = offSet;
					(chart as VBarChart).marginTop = marginTop;
					(chart as VBarChart).marginRight = marginRight;
					(chart as VBarChart).marginBottom = marginBottom;
					(chart as VBarChart).marginLeft = marginLeft;
					(chart as VBarChart).seriesChartNumber = seriesChartNumber.length;
					(chart as VBarChart).barHeight = barHeight;
					(chart as VBarChart).type = typeOfBar;
					//call max value & min value 
					if (positiveValueArrays && positiveValueArrays.length > 0){
						(chart as VBarChart).maxValue = maxValue;
					}
					if (negativeValueArrays && negativeValueArrays.length > 0){
						(chart as VBarChart).minValue = minValue;
					}
					break;
				case HORIZONTAL_BAR: 
					chart = new HBarChart();
					(chart as HBarChart).dataProvider = (typeOfBar == STACKED) ? dataProviderOfStackedBar : dataItems;
					(chart as HBarChart).fill = fill;
					(chart as HBarChart).gap = gap;
					(chart as HBarChart).offSet = offSet;
					(chart as HBarChart).marginTop = marginTop;
					(chart as HBarChart).marginRight = marginRight;
					(chart as HBarChart).marginBottom = marginBottom;
					(chart as HBarChart).marginLeft = marginLeft;
					(chart as HBarChart).seriesChartNumber = seriesChartNumber.length;
					(chart as HBarChart).barWidth = barWidth;
					//call max value & min value 
					if (positiveValueArrays && positiveValueArrays.length > 0){
						(chart as HBarChart).maxValue = maxValue;
					}
					if (negativeValueArrays && negativeValueArrays.length > 0){
						(chart as HBarChart).minValue = minValue;
					}
					(chart as HBarChart).type = typeOfBar;
					//set type for bar
					//trace("type of bar", typeOfBar);
					//if (typeOfBar == STACKED) {
						/*(chart as HBarChart).valueForStackedBar = valueOfSeriesBar;
						(chart as HBarChart).labelForStackedBar = labelOfSeriesBar;
						(chart as HBarChart).sumValueForStackedBar = sumValueStackedBar;
						(chart as HBarChart).fillForStackedBar = ArrayUtilities.groupValue(fillOfStackedBar);
						(chart as HBarChart).titleForStackedBar = ArrayUtilities.groupValue(titleOfStackedBar);*/
					//}
					
					
					/*for(var a:int=0;a<dataItems.length;a++){
						var d:Object = dataItems.getItemAt(a);
						for(var key:String in d){
							if(d[key] instanceof Number)
								trace(d[key]);
						}
					}*/
					

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
					//call max value & min value 
					if (positiveValueArrays && positiveValueArrays.length > 0){
						(chart as LineChart).maxValue = maxValue;
					}
					if (negativeValueArrays && negativeValueArrays.length > 0){
						(chart as LineChart).minValue = minValue;
					}
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
		
		public function get titleField():String
		{
			return _titleField;
		}
		
		public function set titleField(value:String):void
		{
			_titleField = value;
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

		public function get numberLineLandMarkDefault():Number
		{
			return _numberLineLandMarkDefault;
		}

		public function set numberLineLandMarkDefault(value:Number):void
		{
			_numberLineLandMarkDefault = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get numberLineLandMarkForNegativeAxis():Number
		{
			return _numberLineLandMarkForNegativeAxis;
		}

		public function set numberLineLandMarkForNegativeAxis(value:Number):void
		{
			_numberLineLandMarkForNegativeAxis = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get config():Array
		{
			return _config;
		}
		
		public function set config(value:Array):void
		{
			_config = value;
			redrawSkin = true;
			invalidateProperties();
			//trace('config.length', config.length);
		}
	}
}