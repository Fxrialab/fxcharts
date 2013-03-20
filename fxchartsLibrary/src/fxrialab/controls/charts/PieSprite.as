package fxrialab.controls.charts
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fxrialab.utils.DrawHelper;
	
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	
	public class PieSprite extends Sprite
	{
		public function PieSprite()
		{
			super();
			mouseChildren = true; 
		}
		
		private var _data:Object;
		private var origin:Point;
		private var _getFill:Object;
		
		public function get getFill():Object
		{
			return _getFill;
		}

		public function set getFill(value:Object):void
		{
			if(_getFill == value) return;
			_getFill = value;
		}

		public function get data():Object
		{	
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
		}
		
		public function getPositionXOfPie(distance:Number):Number{
			var angle:Number = data.value / data.sumValue * 360/2 + data.startAngle;
			var rad:Number = Math.PI/180 * angle;
			
			return Math.cos(rad) * distance;
		}
		
		public function getPositionYOfPie(distance:Number):Number {
			var angle:Number = data.value / data.sumValue * 360/2 + data.startAngle;
			var rad:Number = Math.PI/180 * angle;
			
			return Math.sin(rad) * distance;
		}
		
		private var txtLabelField:TextField;
		
		public function draw():void {
			//calculate and add label field for pie
			txtLabelField = new TextField();
			var txtLabelFormat:TextFormat = new TextFormat();
			txtLabelFormat.font = "Arial";
			txtLabelFormat.align = "left";
			txtLabelFormat.size = 8;
			txtLabelFormat.color = getFill.color;
			
			var angle:Number = data.value / data.sumValue * 360/2 + data.startAngle;
			
			var moveX:Number = getPositionXOfPie(data.radius);
			var moveY:Number = getPositionYOfPie(data.radius);
			var lineX:Number = getPositionXOfPie(data.radius + 20);
			var lineY:Number = getPositionYOfPie(data.radius + 20);
			var topX:Number = getPositionXOfPie(data.radius + 40);
			var topY:Number = getPositionYOfPie(data.radius + 40);
			
			this.graphics.lineStyle(0.8, 0x00);
			this.graphics.moveTo(moveX + data.centerX, moveY + data.centerY);

			txtLabelField.text = data.label;
			if (angle > 70 && angle < 290) {
				if(angle < 90 || angle > 270){
					if (data.arrays.indexOf(data.label) % 2 == 0) {
						this.graphics.lineTo(topX + data.centerX, topY + data.centerY);
						this.graphics.lineTo(topX + data.centerX + 10, topY + data.centerY);
						txtLabelField.x = topX + data.centerX  + 10;
						txtLabelField.y = topY + data.centerY  - 7;
					}else {
						this.graphics.lineTo(topX + data.centerX, topY + data.centerY);
						this.graphics.lineTo(topX + data.centerX + 30, topY + data.centerY);
						txtLabelField.x = topX + data.centerX + 30;
						txtLabelField.y = topY + data.centerY - 7;
					}
				}else if(angle > 110 && angle < 250) {
					if (data.arrays.indexOf(data.label) % 2 == 0) {
						this.graphics.lineTo(lineX + data.centerX, lineY + data.centerY);
						this.graphics.lineTo(lineX + data.centerX - 10, lineY + data.centerY);
						txtLabelField.x = lineX + data.centerX - txtLabelField.textWidth - 12;
						txtLabelField.y = lineY + data.centerY - 7;
					}else {
						this.graphics.lineTo(lineX + data.centerX, lineY + data.centerY);
						this.graphics.lineTo(lineX + data.centerX - 30, lineY + data.centerY);
						txtLabelField.x = lineX + data.centerX - txtLabelField.textWidth - 32;
						txtLabelField.y = lineY + data.centerY - 7;
					}
				}else {
					if (data.arrays.indexOf(data.label) % 2 == 0) {
						this.graphics.lineTo(topX + data.centerX, topY + data.centerY);
						this.graphics.lineTo(topX + data.centerX - 10, topY + data.centerY);
						txtLabelField.x = topX + data.centerX - txtLabelField.textWidth - 12;
						txtLabelField.y = topY + data.centerY - 7;
					}else {
						this.graphics.lineTo(topX + data.centerX, topY + data.centerY);
						this.graphics.lineTo(topX + data.centerX - 30, topY + data.centerY);
						txtLabelField.x = topX + data.centerX - txtLabelField.textWidth - 32;
						txtLabelField.y = topY + data.centerY - 7;
					}
				}
			}else {
				if (data.arrays.indexOf(data.label) % 2 == 0) {
					this.graphics.lineTo(lineX + data.centerX, lineY + data.centerY);
					this.graphics.lineTo(lineX + data.centerX + 10, lineY + data.centerY);
					txtLabelField.x = lineX + data.centerX + 10;
					txtLabelField.y = lineY + data.centerY - 7;
				}else {
					this.graphics.lineTo(lineX + data.centerX, lineY + data.centerY);
					this.graphics.lineTo(lineX + data.centerX + 30, lineY + data.centerY);
					txtLabelField.x = lineX + data.centerX + 30;
					txtLabelField.y = lineY + data.centerY - 7;
				}
				
			}
			txtLabelField.width = txtLabelField.textWidth + 10;
			txtLabelField.height = 20;
			txtLabelField.setTextFormat(txtLabelFormat);
			/*trace('labelXXX:', txtLabelField.x);
			trace('labelYYY:', txtLabelField.y);*/
			addChild(txtLabelField);
			//get data for draw pie
			var commandsData:Vector.<Object> = DrawHelper.Arc(data.centerX, data.centerY, data.radius, data.startAngle, data.arcData);
			var cmds:Vector.<int> = new Vector.<int>();
			var pts:Vector.<Number> = new Vector.<Number>();
			for(var i:int = 0 ;i < commandsData.length;i++){
				var data:Object = commandsData[i];
				cmds.push(int(data.command));
				pts.push(Number(data.x),Number(data.y));
			}
			//draw with gradient
			this.graphics.lineStyle(2, 0xFFFFFF);
			var gradType:String = GradientType.RADIAL;
			var colors:Array = [getFill.color, getFill.color, getFill.color];
			var alphas:Array = [0.2, 0.4, 0.6];
			var ratios:Array = [25, 245,255];
			var matrix:Matrix = new Matrix();
			
			matrix.createGradientBox(getFill.radius*2, getFill.radius*2, 0, getFill.centerX - getFill.radius, getFill.centerY - getFill.radius);

			this.graphics.beginGradientFill(gradType, colors, alphas, ratios, matrix);
			this.graphics.drawPath(cmds, pts);
			this.graphics.endFill();
			
		}
		
		public function animate(distance:Number):void {
			var angle:Number = data.value / data.sumValue * 360/2 + data.startAngle;
			var rad:Number   = Math.PI/180*angle;

			if(origin == null){//need to explode
				var dx:Number = Math.cos(rad) * distance;
				var dy:Number = Math.sin(rad) * distance;
				origin = new Point(x, y);
				this.x = x + dx;
				this.y = y + dy;
			}else{
				this.x = origin.x;
				this.y = origin.y;
				origin = null;
			}
		}
		
		public var tooltip:Sprite;
		public var txtFieldTooltip:TextField;
		//private var txtToolTip:IUITextField = IUITextField(createInFontContext(IUITextField));
		
		public function showTooltip():void {
			
			txtFieldTooltip = new TextField();
			var txtFormatTooltip:TextFormat = new TextFormat();
			var calcPercent:Number = (data.value/data.sumValue * 100);
			
			txtFormatTooltip.align = 'left';
			txtFormatTooltip.font = 'Verdana';
			txtFormatTooltip.size = 10;
			txtFormatTooltip.color = 0xFFFFFF;
			txtFormatTooltip.leftMargin = txtFormatTooltip.rightMargin = 2;
			
			txtFieldTooltip.defaultTextFormat = txtFormatTooltip;
			txtFieldTooltip.selectable = false;
			txtFieldTooltip.height = 20;
			txtFieldTooltip.autoSize = 'left';
			txtFieldTooltip.htmlText = String(data.label +":"+ calcPercent.toFixed(2) + "%");
			txtFieldTooltip.setTextFormat(txtFormatTooltip);

			tooltip = DrawHelper.Tooltip(txtFieldTooltip.textWidth + 8, txtFieldTooltip.height, 0x1a8948);

			tooltip.addChild(txtFieldTooltip);
			
			var p:Point = new Point(this.mouseX, this.mouseY);
			p = this.localToGlobal(p);
			tooltip.x = p.x - (txtFieldTooltip.textWidth + 8)/2;
			tooltip.y = p.y - tooltip.height - 1;
			
			this.stage.addChild(tooltip);

			//trace('tooltip.xxx:', p.x);
			//trace('tooltip.yyy:', p.y);
			addEventListener(MouseEvent.MOUSE_MOVE, moveTooltip, false, 0, true);
		}
		
		private function moveTooltip(evt:MouseEvent):void {
			if(tooltip){
				tooltip.x = evt.stageX - (txtFieldTooltip.textWidth + 8)/2;
				tooltip.y = evt.stageY - tooltip.height - 1;

				
				/*if(tooltip.x == 537 && tooltip.y == 270){
					/*trace('labelX:', txtLabelField.x);
					trace('labelY:', txtLabelField.y);
					stage.removeChild(tooltip);
					tooltip = null;
				}*/
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