package fxrialab.controls.charts
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fxrialab.utils.DrawHelper;
	
	public class HBarSprite extends Sprite
	{
		public function HBarSprite()
		{
			super();
			mouseChildren = true;
		}
		
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
		}
		
		private var bar:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		
		public function draw():void {
			//trace('value: ',data.value);
			var gradType:String = GradientType.LINEAR;
		//	var colors:Array = [data.fill, data.fill, data.fill];
		//	var alphas:Array = [1, 0.6, 0.3];
		//	var ratios:Array = [0, 30, 255];
			var matrix:Matrix = new Matrix();
			if(data.minValue) {
				matrix.createGradientBox(data.barWidth, data.value, 90*(Math.PI/180), data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom - data.minValue);
			}else {
				matrix.createGradientBox(data.barWidth, data.value, 90*(Math.PI/180), data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom);
			}
			
			//bar = new Sprite();
			bar.graphics.clear();
			bar.graphics.beginFill(data.fill); //beginGradientFill(gradType, colors, alphas, ratios, matrix);
			if(data.minValue){
				bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom - data.minValue, data.barWidth, data.value);
			}else {
				bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom, data.barWidth, data.value);
			}
			bar.graphics.endFill();
			
			addChild(bar);
			
			if (data.redraw)
				removeChild(bar);
			//draw border
			//border = new Sprite();
			//border.graphics.clear();
			//border.graphics.lineStyle(2, 0xFFFFFF);
			if(data.minValue) {
				border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom - data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom - data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.value - data.marginBottom - data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom - data.minValue);
			}else {
				border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.value - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom);
			}

			addChild(border);
			
			//text format for label field and value field				
			var labelFieldFormat:TextFormat = new TextFormat();
			labelFieldFormat.size = data.size;
			labelFieldFormat.font = data.font;
			labelFieldFormat.align = data.align;
			labelFieldFormat.color = data.fill;
			
			var valueFieldFormat:TextFormat = new TextFormat();
			valueFieldFormat.size = data.size;
			valueFieldFormat.font = data.font;
			valueFieldFormat.align = data.align;
			valueFieldFormat.color = 0x000000;

			//draw label field
			var labelField:TextField = new TextField();
			labelField.text = data.label;
			labelField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			if(data.minValue) {
				if(data.value < 0) {
					labelField.y = data.height - data.marginBottom - (data.value - 10) - data.minValue;
				}else {
					labelField.y = data.height - data.marginBottom - (data.value + 12) - data.minValue;
				}
			}else {
				labelField.y = data.height - data.marginBottom + 5;
			}
			labelField.width = data.barWidth;
			labelField.setTextFormat(labelFieldFormat);
			addChild(labelField);
			
			//draw value field
			var valueField:TextField = new TextField();
			valueField.text = data.value;
			valueField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			if(data.minValue) {
				if(data.value < 0) {
					valueField.y = data.height - data.marginBottom - (data.value - 3) - data.minValue;
				}else {
					valueField.y = data.height - data.marginBottom - (data.value + 22) - data.minValue;
				}
			}else {
				valueField.y = data.height - data.marginBottom - (data.value + 12);
			}
			valueField.width = data.barWidth;
			valueField.setTextFormat(valueFieldFormat);
			//addChild(valueField);
			//this.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			//this.addEventListener(Event.ENTER_FRAME, completeHandler, false, 0, true);
		}
		
		private function completeHandler(evt:Event):void 
		{
			this.addChild(bar);
		}
		
		private function resizeHandler(evt:Event):void
		{
			this.removeChild(bar);
		}
		
		private var tooltip:Sprite;
		public var txtFieldTooltip:TextField;
		
		public function showTooltip():void {
			txtFieldTooltip = new TextField();
			var txtFormatTooltip:TextFormat = new TextFormat();
			
			txtFormatTooltip.align = 'left';
			txtFormatTooltip.font = data.font;
			txtFormatTooltip.size = 10;
			txtFormatTooltip.color = 0xFFFFFF;
			txtFormatTooltip.leftMargin = txtFormatTooltip.rightMargin = 4;
			
			txtFieldTooltip.defaultTextFormat = txtFormatTooltip;
			txtFieldTooltip.selectable = false;
			txtFieldTooltip.height = 20;
			//txtFieldTooltip.autoSize = 'center';
			txtFieldTooltip.htmlText = String(data.label +": "+ data.value);
			txtFieldTooltip.setTextFormat(txtFormatTooltip);
			
			tooltip = DrawHelper.Tooltip(txtFieldTooltip.textWidth + 8, txtFieldTooltip.height, 0x1a8948);
			tooltip.addChild(txtFieldTooltip);
			
			var p:Point = new Point(this.mouseX, this.mouseY);
			p = this.globalToLocal(p);
			//trace(this.mouseX);
			//trace('px', p.x);
			
			tooltip.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth;
			tooltip.y = data.height - data.value - data.marginBottom;
			trace('tt.x', tooltip.x);
			this.stage.addChild(tooltip);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveTooltip, false, 0, true);
		}
		
		private function moveTooltip(evt:MouseEvent):void {
			if (tooltip) {
				tooltip.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth;
				tooltip.y = data.height - data.value - data.marginBottom;
			}
		}
		
		public function hideTooltip():void {
			if(tooltip){
				stage.removeChild(tooltip);
				tooltip = null;	
			}
		}

	}
}